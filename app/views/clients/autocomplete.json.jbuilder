json.results @clients do |client|
  json.id client.id
  json.text client.name
end