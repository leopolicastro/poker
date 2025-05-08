class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game, touch: true

  include Chippable
  include Cardable
  has_many :bets, dependent: :destroy

  accepts_nested_attributes_for :bets, allow_destroy: true

  acts_as_list scope: :game
  validates :game_id, uniqueness: {scope: :user_id}
  delegate :name, to: :user

  scope :ordered, -> { order(position: :asc) }
  scope :active, -> { where.not(state: :folded) }
  scope :folded, -> { where(state: :folded) }
  scope :turn, -> { where(turn: true) }
  scope :not_turn, -> { where.not(turn: true) }

  validate :only_one_player_per_turn

  def only_one_player_per_turn
    if game.players.turn.count > 1
      errors.add(:base, "Only one player can have turn at a time")
    end
  end

  enum :table_position, {
    field: 0,
    button: 1,
    small_blind: 2,
    big_blind: 3
  }

  def payout!
    # TODO: this method only works correctly when there is one winner
    chip = game.consolidate_chips
    # give them to the winner
    chip.update!(chippable: self)
    # consolidate the player's chips into one chip record
    consolidate_chips
    game.current_hand.bets.placed.where(player: self).update_all(state: :won)
  end

  def place_bet!(amount:, type:)
    return unless amount.present?
    return if current_holdings < amount

    bets.create!(amount:, round: game.hands.last.rounds.last, type:)
  end

  def small_blind!
    place_bet!(amount: game.small_blind, type: "Bets::Blind")
    super
  end

  def big_blind!
    place_bet!(amount: game.big_blind, type: "Bets::Blind")
    super
  end

  def owes_the_pot
    current_round = game.current_round
    relevant_bets = current_round.bets.where.not(type: ["Bets::Blind", "Bets::Fold"])
    if game.current_round.type == "Rounds::PreFlop"
      # TODO: should this be checking
      game.big_blind - bets.where(round: game.current_round).sum(:amount)
    elsif relevant_bets.any?
      # The highest amount any player has bet in this round
      highest_bet = relevant_bets.group(:player_id).sum(:amount).values.max || 0

      # How much this player has already bet in this round
      my_bet = relevant_bets.where(player: self).sum(:amount)

      # The amount needed to call (can't be negative)
      [highest_bet - my_bet, 0].max
    else
      0
    end
  end

  enum :state, {
    active: 0,
    folded: 1,
    all_in: 2
  }

  has_many :rounds, through: :bets

  def folded?
    state == "folded"
  end

  def still_in?
    state != "folded"
  end

  def dealer?
    table_position == "button"
  end

  def to_the_right
    game.players.ordered.where("position > ?", position).first || game.players.ordered.first
  end

  def to_the_left
    game.players.ordered.where("position < ?", position).last || game.players.ordered.first
  end

  def hand
    h = Hands::Hand.new(cards: cards + game.cards, player_id: id)
    Hands::Index.new(h)
  end

  def buy_in(amount)
    raise if amount > user.current_holdings

    chips = user.split_chips(amount:, chippable: self)
    chips.update(chippable: self)
  end

  def display_name
    name || "Player #{id}"
  end

  def current_hand
    hand&.level&.to_s&.demodulize&.titleize
  end

  private

  def conditions_met?
    game.current_turn.nil? && position >= 4 && game.rounds_count == 1 && game.players.count >= 4
  end
end

# == Schema Information
#
# Table name: players
#
#  id             :integer          not null, primary key
#  dealer         :boolean          default(FALSE), not null
#  position       :integer          default(0), not null
#  state          :integer          default("active"), not null
#  table_position :integer          default("field"), not null
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
