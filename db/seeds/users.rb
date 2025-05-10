user = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "abc123"
end

puts "Created user #{user.email_address}"

user2 = User.find_or_create_by!(email_address: "user@example.com") do |user|
  user.password = "abc123"
end

puts "Created user #{user2.email_address}"
