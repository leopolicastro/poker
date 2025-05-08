class DecksController < ApplicationController
  allow_unauthenticated_access
  def show
    @deck = Deck.find(params[:id])
  end
end
