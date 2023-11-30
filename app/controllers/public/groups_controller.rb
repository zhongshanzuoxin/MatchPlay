class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :update, :show, :destroy, :join, :leave, :user_count, :user_list]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :check_user_can_create_only_one_group, only: [:new, :create]
  include Pagy::Backend

  # グループ一覧を取得するアクション
  def index
    game_title = params[:game_title]
    selected_tags = [params[:tag_ids1], params[:tag_ids2], params[:tag_ids3], params[:tag_ids4]].compact.flatten.map(&:to_i).reject(&:zero?)

    blocked_user_ids = current_user.blocked_user.pluck(:id)
    blocking_user_ids = current_user.blocking_user.pluck(:id)

    groups = Group.includes(:tags).where.not(owner_id: blocked_user_ids + blocking_user_ids)

    if selected_tags.present?
      # タグとゲームタイトルの両方で検索
      groups = groups.search_by_game_title(game_title)
                    .joins(:group_tags)
                    .where(group_tags: { tag_id: selected_tags })
                    .distinct
    else
      # ゲームタイトルのみで検索
      groups = groups.search_by_game_title(game_title)
                    .distinct
    end

    @pagy, @groups = pagy(groups, items: 5)
  end

  # グループに参加するアクション
  def join
    if @group.users.include?(current_user)
      redirect_to groups_path, alert: "すでにグループに参加しています。"
      return
    end

    @group.users << current_user
    if @group.valid?(:join)
      send_notification(@group.owner, "#{current_user.name}さんがあなたのグループに参加しました。")
      redirect_to group_path(@group), notice: "グループに参加しました。"
    else
      @group.users.delete(current_user)
      redirect_to groups_path, alert: "このグループは既に満員です。"
    end
  end

  # グループから退出するアクション
  def leave
    if @group.users.delete(current_user)
      send_notification(@group.owner, "#{current_user.name}さんがグループから退出しました。")
      redirect_to groups_path, notice: "グループから退出しました。"
    else
      redirect_to groups_path, alert: "グループから退出できませんでした。"
    end
  end

  # グループのユーザー数を取得してJSONで返すアクション
  def user_count
    user_count = @group.users.count + 1
    render json: { user_count: user_count, max_users: @group.max_users }
  end

  # グループのユーザーリストを取得してJSONで返すアクション
  def user_list
    users = @group.users
    render json: { user_list: users.map { |user| { id: user.id, name: user.name } } }
  end

  # グループの詳細を表示するアクション
  def show
    @tags = @group.tags

    # ユーザーがグループに参加していないか、オーナーでない場合、リダイレクト
    unless @group.users.include?(current_user) || @group.owner_id == current_user.id
      redirect_to root_path, alert: "このグループに参加していないため、アクセスできません。"
    end
  end

  # グループ新規作成画面
  def new
    @group = Group.new
    @selected_tag_ids = { tag_ids1: [], tag_ids2: [], tag_ids3: [], tag_ids4: [] }
  end

  # グループを作成するアクション
  def create
    @group = Group.new(group_params.except(:tag_ids1, :tag_ids2, :tag_ids3, :tag_ids4))
    @group.owner_id = current_user.id

    # タグのIDを結合して一意の配列にする
    @selected_tag_ids = {
      tag_ids1: params[:group][:tag_ids1],
      tag_ids2: params[:group][:tag_ids2],
      tag_ids3: params[:group][:tag_ids3],
      tag_ids4: params[:group][:tag_ids4]
    }

    tag_ids = @selected_tag_ids.values.flatten.uniq
    tag_ids.each do |tag_id|
      @group.tags << Tag.find(tag_id) unless tag_id.blank?
    end

    if @group.save
      redirect_to group_path(@group), notice: 'グループが作成されました'
    else
      flash.now[:alert] = 'グループの作成に失敗しました'
      render :new
    end
  end

  # グループを更新するアクション
  def update
    ActiveRecord::Base.transaction do
      if @group.update(group_params)
        # タグの更新処理
        tag_ids = params[:group][:tag_ids].reject(&:blank?).map(&:to_i).uniq
        @group.tags = Tag.where(id: tag_ids)

        redirect_to group_path(@group), notice: 'グループが更新されました'
      else
        flash.now[:alert] = 'グループの更新に失敗しました'
        render :edit
      end
    end
  end


  # グループを削除するアクション
  def destroy
    if @group.destroy
      redirect_to root_path, notice: 'グループが削除されました'
    else
      redirect_to root_path, alert: 'グループを削除する権限がありません'
    end
  end

  # グループ編集画面
  def edit
  end

  # ゲームタイトルのサジェスト機能
  def suggest_game_title
    game_titles = Group.search_by_game_title(params[:term]).limit(5)
    render json: game_titles.pluck(:game_title)
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
    redirect_to root_path, alert: "指定されたグループは存在しません。" if @group.nil?
  end

  # グループの編集権限
  def ensure_correct_user
    redirect_to root_path, alert: "この操作を行う権限がありません。" unless @group.owner_id == current_user.id
  end

  # ユーザーがグループを所持しているか判定
  def check_user_can_create_only_one_group
    if current_user.owned_groups.any?
      redirect_to root_path, alert: "既にグループを作成済みです。既存のグループを削除してください。"
    end
  end

  # 通知の作成
  def send_notification(user, message)
    Notification.create(user: user, content: message)
  end

  def group_params
    params.require(:group).permit(:introduction, :game_title, :max_users)
  end
end
