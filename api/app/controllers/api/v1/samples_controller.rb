class Api::V1::SamplesController < ApplicationController
  def new
    begin
      prompt = Prompt.new(prompt_params)
      prompt.response_text = get_response_text(prompt.request_text)
      render json: prompt
    rescue => e
      render json: { error: "エラーが発生しました: #{e.message}" }, status: :unprocessable_entity
    end
  end
  
  def create
    sample = Sample.new(sample_params)
    if sample.save
      create_prompt(sample.id)
      render json: { message: "サンプルとプロンプトの作成に成功しました。" }, status: :created
    else
      render json: { error: "サンプルの作成に失敗しました。" }, status: :unprocessable_entity
    end
  end

  private

  def get_response_text(request)
    begin
      require "openai"
      client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo", 
          messages: [{ role: "user", content: request }],
          temperature: 0.7,
        })
      return response.dig("choices", 0, "message", "content")
    rescue => e
      raise "OpenAIからの応答でエラーが発生しました: #{e.message}"
    end
  end

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text)
  end

  def sample_params
    params.require(:sample).permit(:title, :description)
  end

  def create_prompt(parent_id)
    prompt = Prompt.new(prompt_params)
    prompt.sample_id = parent_id
    unless prompt.save
      raise "プロンプトの作成に失敗しました。"
    end
  end
end