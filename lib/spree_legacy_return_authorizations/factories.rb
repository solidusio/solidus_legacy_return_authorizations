FactoryGirl.define do
  factory :legacy_return_authorization, class: Spree::LegacyReturnAuthorization do
    number '100'
    amount 100.00
    association(:order, factory: :shipped_order)
    reason 'no particular reason'
    state 'received'
  end

  factory :new_legacy_return_authorization, class: Spree::LegacyReturnAuthorization do
    association(:order, factory: :shipped_order)
  end
end
