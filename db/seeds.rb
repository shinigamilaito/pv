# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rol.destroy_all
User.destroy_all
PaymentType.destroy_all

p "Created roles"

admin_rol = Rol.create(name: 'Administrador')
Rol.create(name: 'Vendedor')

User.create({
    name: "admin",
    first_name: "admin",
    username: "admin",
    email: "admin@gmail.com",
    password: 123456,
    password_confirmation: 123456,
    rol: admin_rol
  })

p "Created admin"

PaymentType.create(name: "Efectivo")
PaymentType.create(name: "Tarjeta de Debito")
PaymentType.create(name: "Tarjeta de Crédito")

p "Created payment types"

ClientType.create(name: "Frecuente")
ClientType.create(name: "Ocasional")

p "Created client types"
