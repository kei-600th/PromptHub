class SamplePromptCreationService
  def initialize(sample_params, prompt_params)
    @sample_params = sample_params
    @prompt_params = prompt_params
  end

  def call
    sample = Sample.new(@sample_params)
    return false unless sample.save

    prompt = Prompt.new(@prompt_params.merge(sample_id: sample.id))
    return false unless prompt.save

    sample
  end
end
