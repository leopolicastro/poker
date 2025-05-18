class HandleTurnJob < ApplicationJob
  queue_as :default

  def perform(player)
    player.handle_turn!
  end
end
