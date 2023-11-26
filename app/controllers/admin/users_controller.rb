class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
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
  
  # 全てのメッセージを検索
  def search_all_messages
    @pagy, @messages = pagy(Message.search_by_content(params[:search]), items: 10)
    render :all_messages
  end

  # ユーザー毎のメッセージの検索
  def search_messages
    @pagy, @messages = pagy(@user.messages.search_by_content(params[:search]), items: 8)
    render :show
  end
  
  # ユーザーの検索
  def search_users
    @pagy, @users = pagy(User.search_by_name(params[:search]), items: 10)
    render :index 
  end
  
  # ユーザー名のサジェスト機能
  def suggest_users
    users = User.search_by_name(params[:term]).limit(5)
    render json: users.pluck(:name)
  end

  # メッセージのサジェスト機能
  def suggest_messages
    messages = Message.search_by_content(params[:term]).limit(5)
    render json: messages.pluck(:content)
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
    logger.error "User not found: #{params[:id]}"
    redirect_to admin_users_path, alert: 'ユーザーが見つかりませんでした'
  end


  def user_params
    params.require(:user).permit(:is_active)
  end
end
