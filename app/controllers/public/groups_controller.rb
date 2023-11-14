class Public::GroupsController < ApplicationController
  before_action :set_group, only: [:edit, :update, :show, :destroy, :ensure_correct_user]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :check_user_can_create_only_one_group, only: [:new, :create]

  # グループ一覧を取得するアクション
  def index
    # ユーザーが選んだタグと入力したゲームタイトルを取得
    selected_tags = [
      params[:tag_ids1],
      params[:tag_ids2],
      params[:tag_ids3],
      params[:tag_ids4]
    ].compact.flatten.map(&:to_i)

    # グループと紐づくタグの情報を含むクエリを作成
    groups = Group.includes(:tags)

    # 選択したタグがグループに紐づいている場合、検索条件に追加
    selected_tags.each_with_index do |tag_id, index|
      next if tag_id.blank?

      # タグがグループに紐づいているかをLEFT JOINで確認
      tag_alias = "tag#{index + 1}"
      groups = groups.joins("LEFT JOIN group_tags #{tag_alias} ON #{tag_alias}.group_id = groups.id AND #{tag_alias}.tag_id = #{tag_id.to_i}")
    end

    # 入力されたゲームタイトルがあれば検索条件に追加
    game_title = params[:game_title]
    groups = groups.where("LOWER(groups.game_title) LIKE LOWER(?)", "%#{game_title}%") if game_title.present?

    # ブロックしている情報、ブロックされている情報を取得
    blocked_user_ids = current_user.blocked_user.pluck(:id)
    blocking_user_ids = current_user.blocking_user.pluck(:id)

    # グループをフィルタリング
    @groups = groups.distinct.select do |group|
      tags_diff = selected_tags - group.tag_ids

      # 選択したタグが一部でも含まれているか、ゲームタイトルが一致し、かつブロックされていない場合に選択
      (tags_diff.length < selected_tags.length) || (game_title.present? && !blocked_user_ids.include?(group.owner_id) && !blocking_user_ids.include?(group.owner_id))
    end

    # ブロックしたユーザーが作成したグループを除外
    @groups = @groups.reject { |group| blocked_user_ids.include?(group.owner_id) || blocking_user_ids.include?(group.owner_id) }
  end

  # グループに参加するアクション
  def join
    @group = Group.find(params[:id])

    # グループの現在のメンバー数（オーナーを含む）が最大人数に達しているかをチェック
    if @group.users.count + 1 >= @group.max_users
      # グループが満員の場合、リダイレクトしてアラートを表示
      redirect_to groups_path, alert: "このグループは既に満員です。"
    elsif !@group.users.include?(current_user)
      # ユーザーがまだグループに参加していない場合、ユーザーをグループに追加してリダイレクト
      @group.users << current_user
      redirect_to group_path(@group), notice: "グループに参加しました。"
    else
      redirect_to group_path(@group), alert: "既にグループに参加しています。"
    end
      if @group.users.include?(current_user)
    Notification.create(user_id: @group.owner_id, content: "#{current_user.name}さんがあなたのグループに参加しました。")
      end
  end

  # グループから退出するアクション
  def leave
    @group = Group.find(params[:id])

    if @group.users.include?(current_user)
      # ユーザーがグループに参加している場合、グループから削除してリダイレクト
      @group.users.delete(current_user)
      redirect_to groups_path, notice: "グループから退出しました."
    else
      # ユーザーがグループに参加していない場合、リダイレクトしてアラートを表示
      redirect_to groups_path, alert: "グループから退出できませんでした."
    end
  end

  # グループのユーザー数を取得してJSONで返すアクション
  def user_count
    group = Group.find(params[:id])
    # ユーザー数を計算（オーナーも含めるため +1）
    user_count = group.users.count + 1 

    render json: { user_count: user_count }
  end

  # グループのユーザーリストを取得してJSONで返すアクション
  def user_list
    group = Group.find(params[:id])
    users = group.users

    # ユーザーリストをJSON形式で返す
    render json: { user_list: users.map { |user| { id: user.id, name: user.name } } }
  end

  # グループの詳細を表示するアクション
  def show
    @group = Group.find(params[:id])
    @tags = @group.tags

    # ユーザーがグループに参加していないか、オーナーでない場合、リダイレクト
    unless @group.users.include?(current_user) || @group.owner_id == current_user.id
      redirect_to root_path, alert: "このグループに参加していないため、アクセスできません。"
    end
  end

  # グループ新規作成画面
  def new
    @group = Group.new
  end

  # グループを作成するアクション
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id

    if @group.save
      redirect_to group_path(@group), notice: 'グループが作成されました'
    else
      flash.now[:alert] = 'グループの作成に失敗しました'
      render :new
    end
  end

  # グループを更新するアクション
  def update
    if @group.update(group_params)
      redirect_to group_path(@group), notice: 'グループが更新されました'
    else
      flash.now[:alert] = 'グループの更新に失敗しました'
      render :edit
    end
  end

  # グループを削除するアクション
  def destroy
    if @group.owner_id == current_user.id
      @group.destroy
      redirect_to root_path, notice: 'グループが削除されました'
    else
      redirect_to root_path, alert: 'グループを削除する権限がありません'
    end
  end

  # グループ編集画面
  def edit
    @group = Group.find(params[:id])
  end

  private

  def set_group
    @group = Group.find_by(id: params[:id])
    if @group.nil?
      redirect_to root_path, alert: "指定されたグループは存在しません。"
    end
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

  
  def group_params
    params.require(:group).permit(:introduction, :game_title, :max_users, tag_ids: [])
  end
end
