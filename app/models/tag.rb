class Tag < ApplicationRecord
  has_many :group_tags, dependent: :destroy
  has_many :groups, through: :group_tags
  
  validates :tag_name, presence: true, uniqueness: true
end
