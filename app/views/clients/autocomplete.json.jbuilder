json.results @clients do |client|
  json.id client.id
  json.text client.formal_name
  json.home_phone client.home_phone || 'N/A'
  json.mobile_phone client.mobile_phone || 'N/A'
  json.address client.address
end
