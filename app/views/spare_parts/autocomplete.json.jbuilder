json.results @spare_parts do |spare_part|
  json.id spare_part.id
  json.text spare_part.name
  json.description spare_part.description
end
