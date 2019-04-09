json.results @users do |user|
  json.id user.id
  json.text user.formal_name
end
