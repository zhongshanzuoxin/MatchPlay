# seeds.rb

# 管理者データの追加
Admin.create!(
  email: 'admin@admin.com',
  password: 'admin1'
)

# タグデータの追加
tags = [
  "ボイスチャット有り", "ボイスチャット無し", "気軽に楽しく",
  "誰でも歓迎", "初心者です", "初心者歓迎", "真剣勝負",
  "ランクマッチ", "カジュアルマッチ", "カスタムマッチ"
]

tags = tags.map do |tag_name|
  Tag.find_or_create_by!(tag_name: tag_name)
end

# ユーザーデータの追加
user_names = [
  "Alice", "Bob", "Charlie", "David", "Eve", 
  "Frank", "Grace", "Hannah", "Ivy", "Jake", "John"
]

users = user_names.map do |name|
  User.find_or_create_by!(name: name) do |user|
    user.email = "#{name.downcase}@example.com"
    user.password = "password"
  end
end

# ゲームタイトルの選択肢
game_titles = ["ファイナルファンタジー", "ストリートファイター", "Valorant"]

# グループデータの追加（最初の6人のユーザーに対して）
created_groups = []
users.first(6).each_with_index do |user, index|
  group = Group.find_or_create_by!(owner: user) do |g|
    g.game_title = game_titles.sample
    g.introduction = "楽しい時間を共有しましょう！ゲーマーの皆さん、ぜひ参加してください！"
    g.max_users = 10
  end

  # 各グループにランダムな4つのタグを紐付け
  group.tags << tags.sample(4)
  created_groups << group
end

# グループを作成していない残りのユーザーを最初に作成されたグループに参加させる
users.last(5).each do |user|
  GroupUser.create!(user: user, group: created_groups.first)
end


# テスト用のメッセージコンテンツ
message_contents = [
  "こんにちは、ゲームを始めましょう！", 
  "次のマッチで待っています！", 
  "今晩は一緒にプレイしませんか？", 
  "いいゲームでした、またやりましょう！"
]

created_groups.each do |group|
  group_members = group.users
  group_members.each do |member|
    message_contents.each do |content|
      Message.find_or_create_by!(content: content, user: member, group: group)
    end
  end
end
