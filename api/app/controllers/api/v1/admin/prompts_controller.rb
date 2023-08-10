class Api::V1::Admin::PromptsController < ApplicationController

  def new
    puts "切り分けた先のコントローラーです"
    prompt = Prompt.new(prompt_params)
    prompt.response_text = get_response_text(prompt.request_text)
    render json: prompt
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def get_response_text(request)
    response = openai_chat(request)
    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    raise e.message
  end

  private

  def handle_sample_creation_success(sample)
    create_prompt(sample.id)
    render json: { message: "サンプルとプロンプトの作成に成功しました。" }, status: :created
  rescue RuntimeError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def handle_sample_creation_failure
    render json: { error: "サンプルの作成に失敗しました。" }, status: :unprocessable_entity
  end

  def openai_chat(request)
    client = initialize_openai_client
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: request }],
        temperature: 0.7
      }
    )
    raise StandardError, "OpenAIからの応答でエラーが発生しました: #{response['error']['message']}" if response["error"]

    response
  end

  def initialize_openai_client
    require "openai"
    OpenAI::Client.new(access_token: ENV.fetch('OPENAI_API_KEY', nil))
  end

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text)
  end

end