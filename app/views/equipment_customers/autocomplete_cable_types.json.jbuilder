json.results @cable_types do |cable_type|
  json.id cable_type.id
  json.text cable_type.name
end
