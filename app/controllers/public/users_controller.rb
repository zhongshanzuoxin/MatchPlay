class Public::UsersController < ApplicationController
  before_action :show, only: [:edit, :update, :blocked_users]
  respond_to :html, :js, except: [:blocked_users]

  def show
    @user = User.find(params[:id])
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

def update
  if @user.update(user_params)
    respond_to do |format|
      format.html { redirect_to @user, notice: 'プロフィールが更新されました。' }
    end
  else
    redirect_to user_path(@user), alert: '名前は空で保存できません'
  end
end



  def blocking_users
    @user = User.find(params[:id])
    @blocking_users = @user.blocking_user
  end

  # 新規登録画面でのリロード対策
  def dummy
    redirect_to new_user_registration_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction)
  end
end
