class Group < ApplicationRecord
  belongs_to :user
  has_many :group_tags, dependent: :destroy
  has_many :tags, through: :group_tags
  has_many :chats
end
