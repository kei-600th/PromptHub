class Api::V1::SamplesController < ApplicationController
  def new
    prompt = Prompt.new(prompt_params)
    prompt.response_text = get_response_text(prompt.request_text)
    sample_response(prompt)
  end
  

  def sample_response(prompt)
    render json: {
      request_text: prompt.request_text,
      response_text: prompt.response_text,
    }
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
    params.require(:prompt).permit(:request_text)
  end
end