class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :blocking_users]
  include Pagy::Backend

  # ユーザーの詳細情報を表示
  def show
  end


  # ユーザー情報の編集フォームを表示
  def edit
  # ゲストユーザーの場合は、編集を許可しない
  return if guest_user_restriction_applied?
  
    respond_to do |format|
      format.js
    end
  end


  # ユーザー情報を更新
  def update
    # ゲストユーザーの場合は、更新を許可しない
    return if guest_user_restriction_applied?
    
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to @user, notice: 'プロフィールが更新されました。' }
      end
    else
      error_messages = @user.errors.full_messages.join(', ')
      redirect_to user_path(@user), alert: error_messages
    end
  end


  # ブロックユーザー一覧を表示
  def blocking_users
    # ログインしているユーザーと比較してブロックユーザーを表示
    if @user == current_user
      @pagy, @blocking_users = pagy(@user.blocking_user)
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end


  # 新規登録画面でのリロード対策
  def dummy
    redirect_to new_user_registration_path
  end
  

  private

  def set_user
    @user = User.find(params[:id])
  end

  # ゲストユーザーかどうかを確認し、ゲストユーザーの場合はアラートを表示してリダイレクト
  def guest_user_restriction_applied?
    if @user.guest?
      redirect_to root_path, alert: 'ゲストユーザーはプロフィールを編集できません。'
      return true
    end
    false
  end

  def user_params
    params.require(:user).permit(:name, :introduction)
  end
end
