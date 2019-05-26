json.results @printing_products do |printing_product|
  json.id printing_product.id
  json.code printing_product.code
  json.text printing_product.name
  json.url_img printing_product.imagen_url
  json.contain_unit printing_product.contain_unit
  json.contains printing_product.contains
end
