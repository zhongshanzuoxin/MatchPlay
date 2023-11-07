class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         has_one :group
         has_many :chats
         has_one_attached :profile_image
         
         has_many :blocked, class_name: "Relationship", foreign_key: "blocked_id", dependent: :destroy
         has_many :blocking, class_name: "Relationship", foreign_key: "blocking_id", dependent: :destroy
         has_many :blocking_user, through: :blocked, source: :blocking
         has_many :blocked_user, through: :blocking, source: :blocked

        # ユーザーをブロックする
        def block(user_id)
          blocked.create(blocking_id: user_id)
        end
        # ユーザーのブロックを解除
        def unblock(user_id)
          blocked.find_by(blocking_id: user_id).destroy
        end
        # ブロックしているか確認をおこなう
        def blocking?(user)
          blocking_user.include?(user)
        end

         
        def has_created_group?
          group.present?
        end
end
