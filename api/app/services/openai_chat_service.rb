require 'openai'

class OpenaiChatService
  def initialize(request_text, gpt_model)
    @request_text = request_text
    @gpt_model = gpt_model
  end

  def chat
    client = initialize_openai_client
    response = client.chat(
      parameters: {
        model: @gpt_model,
        messages: [{ role: "user", content: @request_text }],
        temperature: 0.7
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
