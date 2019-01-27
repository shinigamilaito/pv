json.results @generic_prices do |generic_price|
  json.id generic_price.id
  json.text number_to_currency generic_price.price
end
