class SamplePromptCreationService
  attr_reader :error_message

  def initialize(sample_params, prompts_params)
    @sample_params = sample_params
    @prompts_params = prompts_params
  end

  def call
    sample = create_sample
    return false unless sample

    create_prompts(sample.id)
  end

  private

  def create_sample
    sample = Sample.new(@sample_params)
    unless sample.save
      @error_message = "サンプルの作成に失敗しました。"
      return false
    end

    sample
  end

  def create_prompts(sample_id)
    @prompts_params.each do |prompt_param|
      prompt = Prompt.new(prompt_param.merge(sample_id: sample_id))
      unless prompt.save
        @error_message = "プロンプトの作成に失敗しました。"
        return false
      end
    end
    true
  end
end
