# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

200.times do
  Director.create(name: Faker::Fallout.character)
  Movie.create(title: Faker::Coffee.blend_name, director: Director.order("RANDOM()").first)
end

2000.times do
  rick_and_morty = User.create(username: Faker::RickAndMorty.character)
  star_wars = User.create(username: Faker::StarWars.character)
  simpsons = User.create(username: Faker::Simpsons.character)
  rick_and_morty.movies << Movie.all
  star_wars.movies << Movie.all
  simpsons.movies << Movie.all
end
