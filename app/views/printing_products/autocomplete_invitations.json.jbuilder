json.results @printing_products do |printing_product|
  json.id printing_product.id
  json.code printing_product.code
  json.text printing_product.name
  json.sale_unit printing_product.sale_unit
end
