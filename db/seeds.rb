# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

500.times do
  rick_and_morty = User.create(username: Faker::RickAndMorty.character)
  m = Movie.create(title: Faker::Coffee.blend_name)
  rick_and_morty.movies << m
end

500.times do
  simpsons = User.create(username: Faker::Simpsons.character)
  m = Movie.create(title: Faker::Coffee.blend_name)
  simpsons.movies << m
end

500.times do
  star_wars = User.create(username: Faker::StarWars.character)
  m = Movie.create(title: Faker::Coffee.blend_name)
  star_wars.movies << m
end
