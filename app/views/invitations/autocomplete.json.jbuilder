json.results @invitations do |invitation|
  json.id invitation.id
  json.text invitation.name
  json.imagen_url invitation.imagen_url if invitation.imagen?
end
