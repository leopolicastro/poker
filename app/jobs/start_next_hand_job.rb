class StartNextHandJob < ApplicationJob
  queue_as :default

  def perform(game_id:)
    game = Game.find(game_id)
    hand = game.hands.create!
    RotateTablePositionsService.new(game:).call
    # hand.create_pre_flop! # TODO confirm this is good to remove
  end
end
