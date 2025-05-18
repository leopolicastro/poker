# README

## TODO

### Poker engine

- [ ] Handle All Ins Properly (In Progress)
  - [ ] Pot and Sidepot models???
- [ ] Tournament style (raise blinds every x # of hands)

### Poker app

- [ ] UI
- [ ] Player bots to fill tables when not enough players?
- [ ] Ability for users to create their own games and invite their own friends
- [ ]

### Backlog/Ideas

- [ ] Use ruby_llm gem for ai players
  - [] Get people to create their "virtual poker players" which are autonomous/agentic and will play for them??
    - Then we could have tourneys where no people are playing, but their avatar is playing for them, and then it becomes a spectator sport, tamagotchi for adults, ish.
    - People would need the ability to customize their avatars strategy at any time, mid tourney even.
      - Some sort of setting, like aggressive, conservative, defensive etc
    - Leaderboards
    - Prizes (fake money probably)
    - Scheduled tourneys
    -

# Generate basic models and migrations

rails g model chat model_id:string player:references # Example user association
rails g model message chat:references role:string content:text model_id:string input_tokens:integer output_tokens:integer tool_call:references
rails g model ToolCall message:references tool_call_id:string:index name:string arguments:json

```ruby
# app/models/ai_player.rb
class AiPlayer < ApplicationRecord
  belongs_to :user
  has_many :players, through: :user

  # Store AI personality/strategy settings
  enum strategy: {
    aggressive: 0,
    conservative: 1,
    balanced: 2,
    defensive: 3
  }
  validates :name, presence: true

  def make_decision(game_context)
    # Use ruby_llm to make decisions based on game context
    # This will be implemented using the LLM service
  end

  def update_stats(game_result)
    # Update AI player stats after each game
  end
end

# app/services/ai_decision_service.rb
class AiDecisionService
  def self.call(ai_player:, game_context:)
    new(ai_player:, game_context:).call
  end

  def initialize(ai_player:, game_context:)
    @ai_player = ai_player
    @game_context = game_context
    @llm = RubyLLM.new
  end

  def call
    prompt = build_prompt
    response = @llm.complete(prompt)
    parse_decision(response)
  end

  private

  def build_prompt
    # Build prompt using ai_player's template and current game context
    # Include:
    # - Current hand
    # - Pot size
    # - Player positions
    # - Previous actions
    # - AI's strategy/personality
  end

  def parse_decision(response)
    # Parse LLM response into a valid poker action
    # Return appropriate Bet type
  end
end
```
