class StartNextHandJob < ApplicationJob
  queue_as :default

  def perform(game_id:)
    game = Game.find(game_id)
    RotateTablePositionsService.call(game:)
    game.reload.hands.create!
  end
end
