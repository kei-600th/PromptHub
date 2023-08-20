# ※属しているテーブルのデータも全て消えるので注意!!!
Category.destroy_all

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

image_urls = [
  "assets/images/sample_images/pc.jpeg",
  "assets/images/sample_images/talking.jpeg",
  "assets/images/sample_images/buisiness.jpeg",
  "assets/images/sample_images/heart.jpeg",
  "assets/images/sample_images/academy.jpeg",
  "assets/images/sample_images/house.jpeg",
  "assets/images/sample_images/books.jpeg",
  "assets/images/sample_images/designing.jpeg",
]

category_names.each_with_index do |name, index|
  Category.create!(name: name, image: image_urls[index])
end

puts "categories = #{Category.count}"