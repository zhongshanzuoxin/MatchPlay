class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :search_messages]
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
  include Pagy::Backend

  # ユーザー一覧の表示
  def index
    @pagy, @users = pagy(User.all, items: 10)
  end

  # ユーザー詳細の表示
  def show
    @pagy, @messages = pagy(@user.messages, items: 8)
  end

  # メッセージの検索
  def search_messages
    @pagy, @messages = pagy(@user.messages.where("content LIKE ?", "%#{params[:search]}%"), items: 8)
    render :show
  end

  # ユーザー情報の更新
  def update
    if @user.update(user_params)
      # 更新が成功した場合の処理
      redirect_to admin_user_path(@user), notice: 'ユーザー情報が更新されました'
    else
      # 更新が失敗した場合の処理
      flash.now[:alert] = 'ユーザー情報の更新に失敗しました'
      render :show
    end
  end

  private

  # ユーザーをセットする
  def set_user
    @user = User.find(params[:id])
  end

  # ユーザーが見つからない場合の処理
  def user_not_found
    redirect_to admin_users_path, alert: 'ユーザーが見つかりませんでした'
  end


  def user_params
    params.require(:user).permit(:is_active)
  end
end
