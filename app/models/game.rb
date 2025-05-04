class Game < ApplicationRecord
  broadcasts_refreshes

  has_one :deck, as: :deckable, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy
  has_many :bets, through: :rounds

  after_create_commit :create_deck!

  include Chippable
  include Cardable

  enum :state, {
    pending: 0,
    in_progress: 1,
    finished: 2
  }

  def assign_starting_positions!
    players.each_with_index do |player, index|
      player.send(position_map(index))
    end
    players.big_blind.first.set_next_turn
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
    create_round! unless rounds.any?
  end

  scope :ordered, -> { order(created_at: :desc) }

  def create_round!
    rounds.create!(current_turn: first_player)
  end

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

  def last_player
    players.ordered.last
  end

  def next_player
    @next_player ||= players.active.ordered.where("position > ?", current_turn&.position).first || first_player
  end

  def current_round
    rounds.last
  end

  def pot
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
#  id          :integer          not null, primary key
#  big_blind   :integer
#  name        :string           not null
#  small_blind :integer
#  state       :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
