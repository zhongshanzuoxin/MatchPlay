class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :messages
  
  validate :check_user_can_create_only_one_group
  validates :max_users, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  validate :max_users_cannot_be_less_than_current_users
  
  def check_user_can_create_only_one_group
    if owner && owner.groups.where.not(id: self.id).any?
      errors.add(:base, "You can create only one group")
    end
  end
  
  def max_users_cannot_be_less_than_current_users
    return unless max_users.present? && total_users_count.present?

    if max_users < total_users_count
      errors.add(:max_users, "最大人数は現在の参加人数よりも少なくできません")
    end
  end

  # total_users_count メソッドを修正
  def total_users_count
    users.count + 1 # グループのオーナーも人数に含める
  end

end
