class Game < ApplicationRecord
  broadcasts_refreshes

  has_one :deck, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :hands, dependent: :destroy
  has_many :rounds, through: :hands
  has_many :bets, through: :hands

  after_create_commit :create_deck!

  validates :name, presence: true

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
      split_chips(amount: winnings_per_player, chippable: player)
      player.consolidate_chips
      current_hand.bets.placed.where(player:).update_all(state: :won)
    end
  end

  def all_in_payout!(winners:)
    all_in_winners = winners.select(&:all_in?)
    consolidate_chips
    return split_pot_payout!(winners:) if all_in_winners.empty?

    # Get all players who placed bets, sorted by their bet amount
    betting_players = current_hand.bets.placed.includes(:player).map(&:player).uniq
    betting_players.sort_by! { |player| player.current_holdings }

    # Process each all-in player's side pot
    all_in_winners.each do |all_in_player|
      # Find the minimum bet amount for this side pot
      min_bet = all_in_player.current_holdings

      # Get eligible players for this side pot (those who bet at least min_bet)
      eligible_players = betting_players.select { |p| p.current_holdings >= min_bet }

      # Calculate side pot amount
      side_pot_amount = eligible_players.sum { |p| [p.current_holdings, min_bet].min }

      # Find winners eligible for this side pot
      eligible_winners = winners.select { |w| eligible_players.include?(w) }

      # Pay out the side pot
      winnings_per_player = side_pot_amount / eligible_winners.size
      eligible_winners.each do |winner|
        split_chips(amount: winnings_per_player, chippable: winner)
        winner.consolidate_chips
        current_hand.bets.placed.where(player: winner).update_all(state: :won)
      end
    end

    # Pay out the main pot to remaining winners
    remaining_winners = winners - all_in_winners
    if remaining_winners.any?
      main_pot = consolidate_chips
      winnings_per_player = main_pot.value / remaining_winners.size
      remaining_winners.each do |winner|
        winner.chips.create!(value: winnings_per_player)
        winner.consolidate_chips
        current_hand.bets.placed.where(player: winner).update_all(state: :won)
      end
      main_pot.destroy!
    end
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

  def hand_odds
    HandOddsService.call(game: self)
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
