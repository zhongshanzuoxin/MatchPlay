class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :messages

  # グループが削除される前に呼び出されるコールバック
  before_destroy :nullify_messages_group_id
  before_destroy :notify_users_about_deletion, prepend: true
  
  # ゲームタイトルを部分一致で検索するスコープ
  scope :search_by_game_title, -> (game_title) { where("LOWER(game_title) LIKE LOWER(?)", "%#{game_title&.downcase}%") }

  # ゲームタイトルが空かどうか確認
  validates :game_title, presence: true

  # 概要欄の最大文字数確認
  validates :introduction, length: { maximum: 300 }

  # ユーザーが複数のグループを作成するのを防ぐカスタムバリデーション
  validate :check_user_can_create_only_one_group

  # 最大人数が1以上20以下であることを確認
  validates :max_users, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }

  # 最大人数が現在の参加人数以下にならないようにするカスタムバリデーション
  validate :max_users_cannot_be_less_than_current_users

  # ユーザーがグループに参加する際に最大人数を超えないかチェックするカスタムバリデーション
  validate :user_can_join_group, on: :join


  private

  # グループ削除時にユーザーに通知を送信するメソッド
  def notify_users_about_deletion
    users_to_notify = users.to_a
    owner_name = owner.name

    users_to_notify.each do |user|
      notification_message = "#{owner_name}さんが作成したグループは削除されました。"
      Notification.create(user: user, content: notification_message)
    end
  end

  # グループ削除時にメッセージ履歴が消えないようにするための処理
  def nullify_messages_group_id
    messages.update_all(group_id: nil)
  end

  # ユーザーが1つのグループしか作成できないことを確認するバリデーション
  def check_user_can_create_only_one_group
    if owner && owner.groups.where.not(id: self.id).any?
      errors.add(:base, "すでにグループを作成しています")
    end
  end

  # グループの最大人数が現在の参加人数以下に設定されていないことを確認するバリデーション
  def max_users_cannot_be_less_than_current_users
    return unless max_users.present? && total_users_count.present?

    if max_users < total_users_count
      errors.add(:max_users, "最大人数は現在の参加人数よりも少なくできません")
    end
  end

  # グループの総参加人数を計算（オーナーも含める）
  def total_users_count
    users.count + 1 # グループオーナーも参加人数に含むために1を加算
  end

  # 設定された最大人数を超えないか確認するバリデーション
  def user_can_join_group
    if total_users_count > max_users
      errors.add(:base, 'このグループは既に満員です。')
    end
  end
end
