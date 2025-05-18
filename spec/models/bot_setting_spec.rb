require "rails_helper"

RSpec.describe BotSetting, type: :model do
  it "has a valid factory" do
    expect(build(:bot_setting)).to be_valid
  end

  it { is_expected.to belong_to(:user) }

  it { is_expected.to define_enum_for(:strategy).with_values(BotSetting.strategies.keys) }
end

# == Schema Information
#
# Table name: bot_settings
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE), not null
#  instructions :text
#  strategy     :integer          default("conservative"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_bot_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
