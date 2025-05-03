class Game < ApplicationRecord
  broadcasts_refreshes

  has_many :decks, as: :deckable, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :bets, through: :players

  include Chippable
  include Cardable

  enum :state, {
    pending: 0,
    in_progress: 1,
    finished: 2
  }

  scope :ordered, -> { order(created_at: :desc) }

  def add_player(user:)
    players.create(user:)
  end

  def deck
    decks.first
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

  def last_player
    players.ordered.last
  end

  def next_player
    @next_player ||= players.active.ordered.where("position > ?", current_turn.position).first || first_player
  end

  def create_round!
    rounds.create!(current_turn: first_player)
  end

  def current_round
    rounds.last
  end

  def current_bet
    # TODO: thjis is the wrong definition of current bet
    bets.placed.sum(:amount)
  end

  def heads_up?
    players.size == 2
  end

  def three_player?
    players.size == 3
  end
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  state      :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
