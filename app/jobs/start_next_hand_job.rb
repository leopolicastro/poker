class StartNextHandJob < ApplicationJob
  queue_as :default

  def perform(game_id:)
    game = Game.find(game_id)
    game.hands.create!
  end
end
