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

    # Get all players who contributed to the pot
    all_contributors = current_hand.bets.placed.map(&:player).uniq

    # Step 1: Sort all contributors by how much they put in (ascending)
    sorted_contributors = all_contributors.sort_by(&:in_for)

    # Step 2: Build side pots
    pots = []
    remaining_amount = 0

    sorted_contributors.each_with_index do |player, index|
      # Calculate how much this player contributed more than previous player
      previous_contribution = (index > 0) ? sorted_contributors[index - 1].in_for : 0
      additional_contribution = player.in_for - previous_contribution

      # Everyone still in the hand contributes this much to the current pot
      current_pot_amount = additional_contribution * (sorted_contributors.size - index)
      remaining_amount += current_pot_amount

      # Players eligible for this pot are those who put in at least this much
      eligible_players = winners.select { |w| w.in_for >= player.in_for }

      if eligible_players.any?
        pots << {
          amount: current_pot_amount,
          eligible_players: eligible_players
        }
      end
    end

    # Add remaining chips (if any) to the last pot
    if remaining_amount > 0
      if pots.any?
        pots.last[:amount] += remaining_amount
      else
        # If no pots created yet (shouldn't happen but just in case)
        pots << {
          amount: remaining_amount,
          eligible_players: winners
        }
      end
    end

    # Step 3: Sort winners by hand rank (highest rank first)
    # Reversed the sorting to get highest hand first
    sorted_winners = winners.sort_by { |p| Hands::Index::RANKED_HANDS.index(p.hand.level) }.reverse

    # Step 4: Distribute each pot to best eligible player(s)
    pots.each do |pot|
      best_hand_rank = -1
      best_players = []

      # Find the players with the best hand among eligible players
      pot[:eligible_players].each do |player|
        hand_rank = Hands::Index::RANKED_HANDS.index(player.hand.level)
        if hand_rank > best_hand_rank
          best_hand_rank = hand_rank
          best_players = [player]
        elsif hand_rank == best_hand_rank
          best_players << player
        end
      end

      # Split the pot among tied winners
      if best_players.any?
        amount_per_player = pot[:amount] / best_players.size
        best_players.each do |player|
          split_chips(amount: amount_per_player, chippable: player)
          player.consolidate_chips
          current_hand.bets.placed.where(player:).update_all(state: :won)
        end
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
