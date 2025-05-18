require "ruby_llm"

RubyLLM.configure do |config|
  config.openai_api_key = Rails.application.credentials.dig(:openai, :api_key)

  # --- Default Models ---
  # Used by RubyLLM.chat, RubyLLM.embed, RubyLLM.paint if no model is specified.
  # config.default_model = "gpt-4.1-nano-2025-04-14"               # Default: 'gpt-4.1-nano'
  # config.default_embedding_model = "text-embedding-3-small"  # Default: 'text-embedding-3-small'
  # config.default_image_model = "dall-e-3"
end
