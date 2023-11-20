class Public::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :blocking_users, :icon_index, :update_icon]
  include Pagy::Backend

  # ユーザーの詳細情報を表示
  def show
  end


  # ユーザー情報の編集フォームを表示
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
      error_messages = @user.errors.full_messages.join(', ')
      redirect_to user_path(@user), alert: error_messages
    end
  end


  # ユーザーアイコン一覧を表示
  def icon_index
    @pagy, @attachments = pagy(ActiveStorage::Attachment.where(record_type: 'Admin', name: 'image'), items: 4) 
  end


  # ユーザーアイコンを更新
  def update_icon
    begin
      ActiveRecord::Base.transaction do
        @icon = ActiveStorage::Attachment.find(params[:selected_icon_id])
        blob = @icon.blob
        @user.image.attach(blob)
      end
      redirect_to @user, notice: 'アイコンが更新されました。'
    rescue ActiveRecord::RecordNotFound
      # ユーザーまたはアイコンが見つからない場合
      redirect_to some_path, alert: 'ユーザーまたはアイコンが見つかりませんでした。'
    rescue => e
      # その他のエラー
      redirect_to @user, alert: "アイコンの更新に失敗しました: #{e.message}"
    end
  end


  # ブロックユーザー一覧を表示
  def blocking_users
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

  def set_user
    @user = User.find(params[:id])
  end


  def user_params
    params.require(:user).permit(:name, :introduction, :image)
  end
end
