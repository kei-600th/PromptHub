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
      decoded_image = decode_image(prompt_param['image']) if prompt_param['image'].present?
      prompt = Prompt.new(prompt_param.except('image').merge(sample_id: sample_id))
      prompt.image.attach(io: decoded_image, filename: "#{prompt.id}.jpg") if decoded_image
      unless prompt.save
        @error_message = "プロンプトの作成に失敗しました。"
        return false
      end
    end
    true
  end

  def decode_image(data)
    content_type, encoding, string = data.match(/\Adata:(.*?);(.*?),(.*)\z/).captures
    StringIO.new(Base64.decode64(string))
  end
end
