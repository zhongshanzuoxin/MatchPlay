class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :messages, dependent: :destroy 
  
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
end