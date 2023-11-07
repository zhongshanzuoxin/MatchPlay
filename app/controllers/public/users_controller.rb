class Public::UsersController < ApplicationController
  before_action :authenticate_user, only: [:blocked_users]

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # プロフィール情報が更新された場合の処理
      redirect_to user_path(@user)
    else
      # 更新が失敗した場合の処理
      render 'show'
    end
  end
  
  def blocked_users
    @user = User.find(params[:id])
    @blocked_users = @user.blocking_user
  end

  private
  
  def authenticate_user
    unless current_user != @user
      redirect_to root_path, alert: '他のユーザーのブロック一覧にアクセスする権限がありません'
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction)
  end
end