
json.legacy_return_authorizations(@legacy_return_authorizations) do |legacy_return_authorization|
  json.(legacy_return_authorization, *legacy_return_authorization_attributes)
end

json.count @legacy_return_authorizations.count
json.current_page (params[:page] || 1)
json.pages @legacy_return_authorizations.total_pages
