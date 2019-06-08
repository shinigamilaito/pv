json.results @invitations do |invitation|
  json.id invitation.id
  json.text invitation.name
end
