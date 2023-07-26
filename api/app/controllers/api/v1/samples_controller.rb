require "openai"

class Api::V1::SamplesController < ApplicationController
  def new
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo", # Required.
          messages: [{ role: "user", content: "プログラミングの勉強をしている私に自信を与えてくれるメッセージを送ってください"}], # Required.
          temperature: 0.7,
      })
    puts response.dig("choices", 0, "message", "content")
  end
end