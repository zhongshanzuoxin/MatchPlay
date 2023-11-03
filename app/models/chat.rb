class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :group
  
  validates :message, presence: true
end
