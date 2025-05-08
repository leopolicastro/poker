class Game < ApplicationRecord
  broadcasts_refreshes

  has_one :deck, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :hands, dependent: :destroy
  has_many :bets, through: :hands

  after_create_commit :create_deck!

  include Chippable
  include Cardable

  enum :state, {
    pending: 0,
    in_progress: 1,
    finished: 2
  }

  def draw(count: 1, burn_card: false)
    deck.draw(count:, cardable: self, burn_card:)
  end

  def top_hands
    player_hands = players.active.map do |player|
      Hands::Hand.new(cards: player.cards, player_id: player.id)
    end
    res = Hands::Evaluator.find_winners(player_hands, cards.not_burned)
    res.map { |player_id| players.find(player_id) }
  end

  def assign_starting_positions_and_turn!
    players.each_with_index do |player, index|
      player.send(position_map(index))
    end
    # This ends the big blinds turn, and starts the next players turn
    # Big blinds turn is not a real turn, it is just the "first" turn of the round
    players.big_blind.first.to_the_left.update!(turn: true)
  end

  def position_map(index)
    if players.size >= 3
      case index
      when 0
        :button!
      when 1
        :small_blind!
      when 2
        :big_blind!
      else
        :field!
      end
    else
      case index
      when 0
        :big_blind!
      when 1
        :small_blind!
      end
    end
  end

  def in_progress!
    hand = hands.last
    hand.rounds.create!(type: "PreFlop") unless hand.rounds.any?
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
