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

  def payout_winners!(winners:)
    winners.each(&:payout!)
  end

  def split_pot_payout!(winners:)
    pot = consolidate_chips
    winnings_per_player = pot.value / winners.size
    winners.each do |player|
      split_chips(amount: winnings_per_player, chippable: player)
      player.consolidate_chips
      current_hand.bets.placed.where(player:).update_all(state: :won)
    end
  end

  # Takes a collection of players, and pays out the pot to them
  def all_in_payout!(winners:)
    # first check if the winners are all in for the same amount
    # if so, payout the winners normally
    if winners.one? || winners.all? { |p| p.in_for == winners.first.in_for }
      return payout_winners!(winners:)
    end
    # Step 1: Sort players by how much they put in (ascending)
    remaining_players = winners.sort_by(&:in_for)
    remaining_players.map! { |p| {player: p, in_for: p.in_for} }
    pots = []

    # Step 2: Build pots based on all-in amounts
    while remaining_players.any?
      min_in_for = remaining_players.first[:in_for]
      eligible = remaining_players.dup
      pot_amount = min_in_for * eligible.size
      pots << {
        amount: pot_amount,
        eligible_players: eligible.map { |p| p[:player] }
      }
      # Subtract min_contrib from everyone
      remaining_players.each do |p|
        p[:in_for] -= min_in_for
      end
      # remaining_players.reject! { |p| p[:in_for] <= 0 }
      remaining_players.reject! { |p| p[:in_for] == 0 }
    end
    # Step 3: Sort all players by hand rank (0 is worst)

    sorted_winners = winners.sort_by { |p| Hands::Index::RANKED_HANDS.index(p.hand.level) }
    # Step 4: Distribute each pot to best eligible player(s)
    pots.each do |pot|
      sorted_winners.each do |player|
        next unless pot[:eligible_players].include?(player)

        split_chips(amount: pot[:amount], chippable: player)
        player.consolidate_chips
        current_hand.bets.placed.where(player:).update_all(state: :won)
      end
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
