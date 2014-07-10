object false
child(@legacy_return_authorizations => :legacy_return_authorizations) do
  attributes *legacy_return_authorization_attributes
end
node(:count) { @legacy_return_authorizations.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @legacy_return_authorizations.num_pages }
