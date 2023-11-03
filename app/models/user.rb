class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_many :block_users, foreign_key: 'blocker_id', class_name: 'BlockUser', dependent: :destroy
         has_many :blocked_users, through: :block_users, source: :blocked
         has_many :blocked_by_users, foreign_key: 'blocked_id', class_name: 'BlockUser', dependent: :destroy
         has_many :blocked_users_by, through: :blocked_by_users, source: :blocker
         has_one :group
         has_many :chats

         def block!(user)
           blocks.create(blocked: user)
         end

         def unblock!(user)
           blocks.find_by(blocked: user).destroy
         end
end
