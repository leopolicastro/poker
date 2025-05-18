class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :players, dependent: :destroy

  has_one :bot_settings, dependent: :destroy, class_name: "BotSetting"

  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  include Chippable

  after_create_commit :create_bot_settings

  private

  def create_bot_settings
    BotSetting.create(user: self)
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
