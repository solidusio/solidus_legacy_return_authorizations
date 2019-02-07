require 'spec_helper'

describe Spree::LegacyReturnAuthorization do
  let(:stock_location) { Spree::StockLocation.create(:name => "test") }
  let(:order) { FactoryBot.create(:shipped_order) }

  let(:variant) { order.variants.first }
  let(:legacy_return_authorization) { Spree::LegacyReturnAuthorization.new(:order => order, :stock_location_id => stock_location.id) }

  context "save" do
    let(:order) { Spree::Order.create }

    it "should be invalid when order has no inventory units" do
      legacy_return_authorization.save
      expect(legacy_return_authorization.errors[:order]).to eq(["has no shipped units"])
    end
  end

  describe ".before_create" do
    describe "#generate_number" do
      context "number is assigned" do
        let(:legacy_return_authorization) { Spree::LegacyReturnAuthorization.new(number: '123') }

        it "should return the assigned number" do
          legacy_return_authorization.save
          expect(legacy_return_authorization.number).to eq('123')
        end
      end

      context "number is not assigned" do
        let(:legacy_return_authorization) { Spree::LegacyReturnAuthorization.new(number: nil) }

        before { allow(legacy_return_authorization).to receive_messages valid?: true }

        it "should assign number with random RMA number" do
          legacy_return_authorization.save
          expect(legacy_return_authorization.number).to match(/RMA\d{9}/)
        end
      end
    end
  end

  context "add_variant" do
    context "on empty rma" do
      it "should associate inventory units as shipped" do
        legacy_return_authorization.add_variant(variant.id, 1)
        expect(legacy_return_authorization.inventory_units.where(state: 'shipped').size).to eq 1
      end

      it "should update order state" do
        expect(order).to receive(:authorize_return!)
        legacy_return_authorization.add_variant(variant.id, 1)
      end
    end

    context "on rma that already has inventory_units" do
      before do
        legacy_return_authorization.add_variant(variant.id, 1)
      end

      it "should not associate more inventory units than there are on the order" do
        legacy_return_authorization.add_variant(variant.id, 1)
        expect(legacy_return_authorization.inventory_units.size).to eq 1
      end

      it "should not update order state" do
        expect{legacy_return_authorization.add_variant(variant.id, 1)}.to_not change{order.state}
      end
    end
  end

  context "can_receive?" do
    it "should allow_receive when inventory units assigned" do
      allow(legacy_return_authorization).to receive_messages(:inventory_units => [1,2,3])
      expect(legacy_return_authorization.can_receive?).to be_truthy
    end

    it "should not allow_receive with no inventory units" do
      allow(legacy_return_authorization).to receive_messages(:inventory_units => [])
      expect(legacy_return_authorization.can_receive?).to be_falsey
    end
  end

  context "receive!" do
    let(:inventory_unit) { order.shipments.first.inventory_units.first }

    context "to the initial stock location" do
      before do
        legacy_return_authorization.update!(
          inventory_units: [inventory_unit],
          stock_location_id: inventory_unit.shipment.stock_location.id
        )

        allow(Spree::Adjustment).to receive(:create)
      end

      it "should mark all inventory units are returned" do
        legacy_return_authorization.receive!
        expect(inventory_unit.reload).to be_returned
      end

      it "should add credit for specified amount" do
        legacy_return_authorization.amount = 20
        expect(Spree::Adjustment).to receive(:create).with(adjustable: order, amount: -20, label: I18n.t('spree.legacy_rma_credit'), source: legacy_return_authorization)
        legacy_return_authorization.receive!
      end

      it "should update order state" do
        if Spree.solidus_gem_version >= Gem::Version.new('2.4.0')
          expect(order).to receive :recalculate
        else
          expect(order).to receive :update!
        end

        legacy_return_authorization.receive!
      end

      context 'with Config.track_inventory_levels == true' do
        before { Spree::Config.track_inventory_levels = true }

        it "should update the stock item counts in the stock location" do
          count_on_hand = inventory_unit.find_stock_item.count_on_hand
          legacy_return_authorization.receive!
          expect(inventory_unit.find_stock_item.count_on_hand).to eq(count_on_hand + 1)
        end
      end

      context 'with Config.track_inventory_levels == false' do
        before do
          expect(Spree::StockItem).not_to receive(:find_by)
          expect(Spree::StockMovement).not_to receive(:create!)
          Spree::Config.track_inventory_levels = false
        end

        it "should NOT update the stock item counts in the stock location" do
          count_on_hand = inventory_unit.find_stock_item.count_on_hand
          legacy_return_authorization.receive!
          expect(inventory_unit.find_stock_item.count_on_hand).to eql count_on_hand
        end
      end
    end

    context "to a different stock location" do
      let(:new_stock_location) { FactoryBot.create(:stock_location, :name => "other") }

      before do
        legacy_return_authorization.update!(
          :stock_location_id => new_stock_location.id,
          :inventory_units => [inventory_unit],
          :amount => -20
        )
        Spree::Config.track_inventory_levels = true
      end

      it "should update the stock item counts in new stock location" do
        count_on_hand = Spree::StockItem.where(variant_id: inventory_unit.variant_id, stock_location_id: new_stock_location.id).first.count_on_hand
        legacy_return_authorization.receive!
        expect(Spree::StockItem.where(variant_id: inventory_unit.variant_id, stock_location_id: new_stock_location.id).first.count_on_hand).to eq(count_on_hand + 1)
      end

      it "should NOT raise an error when no stock item exists in the stock location" do
        if Spree.solidus_gem_version >= Gem::Version.new('2.5.0')
          inventory_unit.find_stock_item.discard
        else
          inventory_unit.find_stock_item.destroy
        end

        expect { legacy_return_authorization.receive! }.not_to raise_error
      end

      it "should not update the stock item counts in the original stock location" do
        count_on_hand = inventory_unit.find_stock_item.count_on_hand
        legacy_return_authorization.receive!
        expect(inventory_unit.find_stock_item.count_on_hand).to eq(count_on_hand)
      end
    end
  end

  context "force_positive_amount" do
    it "should ensure the amount is always positive" do
      legacy_return_authorization.amount = -10
      legacy_return_authorization.send :force_positive_amount
      expect(legacy_return_authorization.amount).to eq(10)
    end
  end

  context "after_save" do
    it "should run correct callbacks" do
      expect(legacy_return_authorization).to receive(:force_positive_amount)
      legacy_return_authorization.run_callbacks(:save)
    end
  end

  context "currency" do
    before { allow(order).to receive(:currency) { "ABC" } }
    it "returns the order currency" do
      expect(legacy_return_authorization.currency).to eq("ABC")
    end
  end

  context "display_amount" do
    it "returns a Spree::Money" do
      legacy_return_authorization.amount = 21.22
      expect(legacy_return_authorization.display_amount).to eq(Spree::Money.new(21.22))
    end
  end

  context "returnable_inventory" do
    skip "should return inventory from shipped shipments" do
      expect(legacy_return_authorization.returnable_inventory).to eq([inventory_unit])
    end

    skip "should not return inventory from unshipped shipments" do
      expect(legacy_return_authorization.returnable_inventory).to eq([])
    end
  end

  context "destroy" do
    before do
      legacy_return_authorization.add_variant(variant.id, 1)
      legacy_return_authorization.destroy
    end

    # Regression test for https://github.com/spree/spree/issues/4935
    it "disassociates inventory units" do
      expect(Spree::InventoryUnit.where(legacy_return_authorization_id: legacy_return_authorization.id).count).to eq 0
    end
  end
end
