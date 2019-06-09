json.results @printing_products do |printing_product|
  json.id printing_product.id
  json.text "#{printing_product.name} (#{printing_product.sale_unit})"
  json.code printing_product.code
end
