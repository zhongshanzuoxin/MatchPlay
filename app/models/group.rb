class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :messages
  
  validate :check_user_can_create_only_one_group
  validates :max_users, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }
  
  def check_user_can_create_only_one_group
    if owner && owner.groups.where.not(id: self.id).any?
      errors.add(:base, "You can create only one group")
    end
  end
  
end
