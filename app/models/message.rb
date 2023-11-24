class Message < ApplicationRecord
  belongs_to :user
  belongs_to :group
  
  # メッセージを部分一致で検索するスコープ
  scope :search_by_content, -> (content) { where("content LIKE ?", "%#{content}%") }
  
  validates :content, presence: true
end
