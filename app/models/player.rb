class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game, touch: true

  acts_as_list scope: :game
  validates :game_id, uniqueness: {scope: :user_id}
  delegate :name, to: :user

  scope :ordered, -> { order(position: :asc) }
  scope :active, -> { where.not(state: :folded) }
  scope :folded, -> { where(state: :folded) }

  scope :field, -> { where(table_position: :field) }
  scope :button, -> { where(table_position: :button) }
  scope :small_blind, -> { where(table_position: :small_blind) }
  scope :big_blind, -> { where(table_position: :big_blind) }

  delegate :board, to: :game

  after_update_commit :sync_turns, if: -> { turn_changed? && turn? }

  include Chippable
  include Cardable
  include Bets

  def dealer?
    table_position == "button"
  end

  def to_the_left
    game.players.ordered.where("position > ?", position).first || game.players.ordered.first
  end

  def to_the_right
    game.players.ordered.where("position < ?", position).last || game.players.ordered.last
  end

  def hand
    h = Hands::Hand.new(cards: cards + board, player_id: id)
    Hands::Index.new(h)
  end

  def active?
    !folded? && game.current_round.state != "setup"
  end

  def buy_in(amount)
    raise if amount > user.current_holdings

    chips = user.split_chips(amount:, chippable: self)
    chips.update(chippable: self)
  end

  def set_next_turn
    to_the_left.start_turn!
  end

  def current_bet
    bets.placed.sum(:amount)
  end

  private

  def conditions_met?
    game.current_turn.nil? && position >= 4 && game.rounds_count == 1 && game.players.count >= 4
  end

  def sync_turns
    game.players.where.not(id: id).each do |player|
      player.end_turn! if player.turn?
    end
  end

  def start_turn!
    update(turn: true)
  end

  def end_turn!
    update(turn: false)
  end
end

# == Schema Information
#
# Table name: players
#
#  id             :integer          not null, primary key
#  dealer         :boolean          default(FALSE), not null
#  position       :integer          default(0), not null
#  table_position :string           default("field"), not null
#  turn           :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :integer          not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#  index_players_on_user_id  (user_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#  user_id  (user_id => users.id)
#
