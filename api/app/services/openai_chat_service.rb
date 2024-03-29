require 'openai'

class OpenaiChatService
  def initialize(messages, gpt_model)
    @messages = messages
    @gpt_model = gpt_model
  end

  def chat
    response = initialize_openai_client.chat(
      parameters: {
        model: @gpt_model,
        messages: @messages,
        temperature: 0.7,
        max_tokens: 600
      }
    )
    raise StandardError, "OpenAIからの応答でエラーが発生しました: #{response['error']['message']}" if response["error"]

    response.dig("choices", 0, "message", "content")
  end

  private

  def initialize_openai_client
    OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY', nil))
  end
end
