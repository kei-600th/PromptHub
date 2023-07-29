class Api::V1::SamplesController < ApplicationController
  def new
    prompt = Prompt.new(prompt_params)
    prompt.response_text = get_response_text(prompt.request_text)
    render json: prompt
  end
  
  def create
    sample = Sample.new(sample_params)
    if sample.save
      create_prompt(sample.id)
    else
      puts "サンプルの作成に失敗しました。"
    end
  end

  def create_prompt(parent_id)
    prompt = Prompt.new(prompt_params)
    prompt.sample_id = parent_id
    if prompt.save
      puts "プロンプトとサンプルの作成に成功しました。"
    else
      puts "プロンプトの作成に失敗しました。"
    end
  end


  private

  def get_response_text(request)
    require "openai"
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", 
          messages: [{ role: "user", content: request}],
          temperature: 0.7,
      })
    return response.dig("choices", 0, "message", "content")
  end

  def prompt_params
    params.require(:prompt).permit(:request_text, :response_text)
  end

  def sample_params
    params.require(:sample).permit(:title, :description)
  end
end