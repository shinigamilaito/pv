json.results @generic_prices do |generic_price|
  json.id generic_price.id
  json.text generic_price.name_price
end
