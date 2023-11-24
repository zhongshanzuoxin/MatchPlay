class Public::ProfileIconsController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  # アイコン一覧をページネーションで表示する
  def index
    @pagy, @profile_icons = pagy(ProfileIcon.all, items: 4)
  end

  # プロフィールアイコンを更新する
  def update
    profile_icon = ProfileIcon.find(params[:id])
    
    if current_user.update(profile_icon: profile_icon)
      redirect_to user_path(current_user), notice: 'プロフィールアイコンが更新されました'
    else
      redirect_to user_path(current_user), alert: 'アイコンの更新に失敗しました'
    end
  end
  
end
