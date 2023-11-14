class Public::UsersController < ApplicationController
  before_action :show, only: [:edit, :update, :blocked_users]

  # ユーザーの詳細情報を表示
  def show
    @user = User.find(params[:id])
  end

  # ユーザー情報の編集フォームを表示 (JavaScript レスポンス対応)
  def edit
    respond_to do |format|
      format.js
    end
  end

  # ユーザー情報を更新
  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to @user, notice: 'プロフィールが更新されました。' }
      end
    else
      redirect_to user_path(@user), alert: '名前は空で保存できません'
    end
  end

  # ブロックユーザー一覧を表示
  def blocking_users
    @user = User.find(params[:id])
    # ログインしているユーザーと比較してブロックユーザーを表示
    if @user == current_user
      @blocking_users = @user.blocking_user
    else
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  # 新規登録画面でのリロード対策
  def dummy
    redirect_to new_user_registration_path
  end

  private

  # ユーザー情報のパラメーターを許可
  def user_params
    params.require(:user).permit(:name, :introduction)
  end
end
