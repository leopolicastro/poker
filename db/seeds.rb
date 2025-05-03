# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[1, 2, 3, 4, 5].each do |i|
  User.find_or_create_by!(email_address: "demo-player#{i}@example.com") do |user|
    user.password = "password"
  end
end

puts "Created #{User.count} users"

@game = Game.find_or_create_by!(name: "Demo Game") do |game|
  game.players.create!(user: User.find_by(email_address: "demo-player1@example.com"))
  game.players.create!(user: User.find_by(email_address: "demo-player2@example.com"))
  game.players.create!(user: User.find_by(email_address: "demo-player3@example.com"))
  game.players.create!(user: User.find_by(email_address: "demo-player4@example.com"))
  game.players.create!(user: User.find_by(email_address: "demo-player5@example.com"))
end

puts "Created #{@game.name} with #{@game.players.count} players"
