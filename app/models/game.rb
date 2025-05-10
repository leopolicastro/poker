class Game < ApplicationRecord
  broadcasts_refreshes

  has_one :deck, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :hands, dependent: :destroy
  has_many :rounds, through: :hands
  has_many :bets, through: :hands

  after_create_commit :create_deck!

  include Chippable
  include Cardable

  enum :state, {
    pending: 0,
    in_progress: 1,
    finished: 2
  }

  def split_pot_payout!(winners:)
    pot = consolidate_chips
    winnings_per_player = pot.value / winners.size
    winners.each do |player|
      player.chips.create!(value: winnings_per_player)
      player.consolidate_chips
      current_hand.bets.placed.where(player:).update_all(state: :won)
    end
    pot.destroy!
  end

  def draw(count: 1, burn_card: false)
    deck.draw(count:, cardable: self, burn_card:)
  end

  def top_hands
    player_hands = players.active.map do |player|
      Hands::Hand.new(cards: player.cards, player_id: player.id)
    end
    res = Hands::Evaluator.find_winners(player_hands, cards)
    res.map { |player_id| players.find(player_id) }
  end

  def assign_starting_positions!
    players.each_with_index do |player, index|
      player.send(position_map(index))
    end
  end

  def position_map(index)
    case index
    when 0
      (players.size >= 3) ? :button! : :big_blind!
    when 1
      :small_blind!
    when 2
      :big_blind!
    else
      :field!
    end
  end

  def in_progress!
    current_hand.rounds.create!(type: "Rounds::PreFlop") unless current_hand.rounds.any?
    super
  end

  scope :ordered, -> { order(created_at: :desc) }

  def add_player(user:)
    players.create(user:)
  end

  def current_turn
    players.find_by(turn: true)
  end

  def chip_leader
    players.max_by(&:current_holdings)
  end

  def first_player
    players.ordered.first || players.create(user: User.first)
  end

  def next_player
    @next_player ||= players.active.ordered.where("position > ?", current_turn&.position).first || first_player
  end

  def current_round
    current_hand.rounds.last
  end

  def current_hand
    hands.last
  end

  def pot
    current_hand.bets.placed.sum(:amount)
  end

  def heads_up?
    players.size == 2
  end

  def three_player?
    players.size == 3
  end

  def on_the_button
    players.button.first
  end

  def first_hand?
    hands.count == 1
  end
end

# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  big_blind   :integer
#  name        :string           not null
#  small_blind :integer
#  state       :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
