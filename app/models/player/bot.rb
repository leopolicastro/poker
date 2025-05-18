module Player::Bot
  def handle_turn_job!
    return unless turn_previously_changed? && turn?

    HandleTurnJob.set(wait: 5.seconds).perform_later(self)
  end

  def handle_turn!
    return unless active? && turn? && bot?

    call_bot
  end

  def call_bot
    # return unless bot? && turn?

    # prepare the game_context
    #   - game_context = {
    #     community_cards: game.cards,
    #     player_cards: cards,
    #     total_in_the_pot: game.current_round.bets.sum(:amount),
    #     player_in_for: in_for,
    #     player_hand: hand,
    #     player_position: position,
    #     strategy: user.bot_settings.strategy,
    #     round_bets: game.current_round.bets,
    #     hand_bets: game.current_hand.bets,
    #   }
    # get the bot's strategy and custom instructions
    chat = RubyLLM.chat
    # chat.with_instructions(bot_instructions, replace: true)

    response = chat.ask(bot_question)
    action, amount = response.content.split(" ")

    bets.create!(type: "Bets::#{action}", amount: handle_amount(amount, action), round: game.current_round)
  end

  def handle_amount(amount, action)
    if action == "Fold"
      return 0
    elsif action == "Call"
      return owes_the_pot
    elsif action == "Raise"
      return amount.to_i
    elsif action == "Check"
      return [owes_the_pot, 0].max
    elsif action == "AllIn"
      return current_holdings
    end

    amount
  end

  def game_context
    {
      current_player: as_json(
        only: %i[id display_name cards position state turn table_position bets_this_hand],
        methods: %i[current_holdings in_for current_hand top_five_cards_to_s],
        include: {
          cards: {
            only: %i[id suit value],
            methods: %i[to_s]
          }
        }
      )
    }
  end

  def bot_question
    <<~QUESTION
      Based on the following game context, what is the best action to take?

      This is your game context:

      #{game_context.to_json}

      This is the game context of the other players:

      #{game.context.to_json}

      If you have a good hand (Pair or better), you should raise.
      If you have a bad hand (No pair or less), you should fold.
      #
      #{bot_instructions}
    QUESTION
  end

  def bot_instructions
    <<~INSTRUCTIONS
      Your response should ALWAYS be two strings:
        The first string is the action to take:
          - Fold
          - Call
          - Raise
          - Check
          - AllIn

      The second string is the amount to bet:
        - If the action is Fold, Call, Check, or AllIn, the amount should be 0.
        - If the action is Raise, the amount should be the amount to raise to.
        - If the action is AllIn, the amount should be the amount to all in for.
        - For example, if the action is Fold, the response should be "Fold 0".
          - If the action is Call, the response should be "Call 0".
          - If the action is Raise, the response should be "Raise 100".
          - If the action is Check, the response should be "Check 0".
          - If the action is AllIn, the response should be "AllIn 0".
    INSTRUCTIONS
  end
end
