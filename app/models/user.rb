class User < ApplicationRecord
  # Deviseの認証モジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザーとグループの関連付け
  has_many :group_users
  has_many :groups, through: :group_users

  # ユーザーが所有するグループの関連付け
  has_many :owned_groups, class_name: 'Group', foreign_key: :owner_id
  has_many :messages

  # 通知モデルへの関連付けを追加
  has_many :notifications, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  # ブロック関連の関連付け
  # ユーザーがブロックされている関係
  has_many :blocked, class_name: "Relationship", foreign_key: "blocked_id", dependent: :destroy

  # ユーザーが他のユーザーをブロックしている関係
  has_many :blocking, class_name: "Relationship", foreign_key: "blocking_id", dependent: :destroy

  # 関連付けを通してブロックしているユーザーとブロックされているユーザーを取得
  has_many :blocking_user, through: :blocking, source: :blocked
  has_many :blocked_user, through: :blocked, source: :blocking


  # ユーザーの is_active 属性が false に変更されたときに呼び出されるコールバック
  after_update :handle_inactive_status, if: -> { saved_change_to_is_active? && !is_active }


  # ユーザー名と自己紹介のバリデーション
  validates :name,
    presence: { message: 'は空で保存できません' },
    length: { maximum: 15, too_long: 'は%{count}文字以内で入力してください' },
    format: { without: /(\w)\1{4,}/, message: '同じ文字は連続して使用できません' }
  validates :introduction,
    presence: { message: 'は空では保存できません' },
    length: { maximum: 300, too_long: '300字以内にしてください' }

  # ゲストアカウントの処理
  def self.create_guest
    guest_name = "ゲストユーザー#{SecureRandom.hex(4)}"
    create!(email: "guest_#{SecureRandom.hex(8)}@example.com", password: Devise.friendly_token[0, 20], name: guest_name, guest: true)
    # 必要に応じて他の初期設定を行う
  end


  # アイコンについての処理
  def default_profile_icon(size: [width, height])
    'default_icon.png'
  end

  # アイコンについての処理
  def get_profile_icon(size: [350, 350])
    if image.attached?
      image.variant(resize_to_limit: size)
    else
      default_profile_icon(size: size)
    end
  end

  # ユーザーをブロックする
  def block(user_id)
    blocking.create(blocked_id: user_id)
  end

  # ユーザーのブロックを解除する
  def unblock(user_id)
    blocking_relation = blocking.find_by(blocked_id: user_id)
    blocking_relation&.destroy
  end

  # 特定のユーザーをブロックしているかどうかを確認する
  def blocking?(user)
    blocking_user.include?(user)
  end

  # ブロックされているユーザーが所有するグループを取得する
  def blocked_users_groups
    blocked_user.map(&:owned_groups).flatten
  end

  private

  # is_activeがfalseになった場合に実行される処理
  def handle_inactive_status
    destroy_related_groups
    leave_groups
  end

  # ユーザーが参加しているグループから退出
  def leave_groups
    group_users.destroy_all
  end

  # is_activeがfalseになった場合グループを自動削除
  def destroy_related_groups
    owned_groups.destroy_all
  end

end
