Admin.create!(
   email: 'admin@admin',
   password: 'admin1'
)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
tags = [
  "ボイスチャット有り",
  "ボイスチャット無し",
  "気軽に楽しく",
  "誰でも歓迎",
  "初心者です",
  "初心者歓迎",
  "真剣勝負",
  "ランクマッチ",
  "カジュアルマッチ",
  "カスタムマッチ"
]

tags.each do |tag_name|
  Tag.create(tag_name: tag_name)
end
