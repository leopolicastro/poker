def seed(file)
  load Rails.root.join("db", "seeds", "#{file}.rb")
end

puts "Seeding #{Rails.env} database"

seed :users
seed :demo_game
