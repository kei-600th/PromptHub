category_names = [
  "PC・プログラミング",
  "語学",
  "ビジネス",
  "メンタルケア",
  "学術",
  "暮らし・生活",
  "作品・エンタメ",
  "デザイン・Web制作"
]

category_names.each do |name|
  Category.create!(name: name)
end
