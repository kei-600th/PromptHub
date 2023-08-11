class SamplePromptCreationService
  attr_reader :error_message

  def initialize(sample_params, prompt_params)
    @sample_params = sample_params
    @prompt_params = prompt_params
  end

  def call
    sample = Sample.new(@sample_params)
    unless sample.save
      @error_message = "サンプルの作成に失敗しました。"
      return false
    end

    prompt = Prompt.new(@prompt_params.merge(sample_id: sample.id))
    unless prompt.save
      @error_message = "プロンプトの作成に失敗しました。"
      return false
    end

    sample
  end
end
