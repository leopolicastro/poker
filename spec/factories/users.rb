FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.email }
    password { "password" }
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean          default(FALSE)
#  email_address   :string           not null
#  name            :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
