class Public::GroupsController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :check_user_can_create_only_one_group, only: [:new, :create]

def index
  selected_tags = [
    params[:tag_ids1],
    params[:tag_ids2],
    params[:tag_ids3],
    params[:tag_ids4]
  ].compact.flatten.map(&:to_i)

  game_title = params[:game_title]

  # タグとゲームタイトルの検索クエリを組み立てる
  groups = Group.includes(:tags)

  # タグがグループに紐付けられている場合のみ検索条件に追加
  selected_tags.each_with_index do |tag_id, index|
    next if tag_id.blank?

    groups = groups.joins("LEFT JOIN group_tags tag#{index + 1} ON tag#{index + 1}.group_id = groups.id AND tag#{index + 1}.tag_id = #{tag_id.to_i}")
  end

  groups = groups.where("LOWER(groups.game_title) LIKE LOWER(?)", "%#{ActiveRecord::Base.sanitize_sql_like(game_title)}%") if game_title.present?

  # グループに紐付いている全てのタグを取得
  @selected_tags = Tag.joins(:group_tags).where(id: selected_tags).distinct

  # 選択したタグに紐づいていない他のタグを取得
  @other_tags = Tag.joins(:group_tags).where.not(id: selected_tags).distinct

  # 一つでも一致していれば表示する
  @groups = groups.distinct.select { |group| (selected_tags - group.tag_ids).length < selected_tags.length || game_title.present? }
end



def join
  @group = Group.find(params[:id])

  if @group.users.count < @group.max_users
    if !@group.users.include?(current_user)
      @group.users << current_user
    end
    redirect_to group_path(@group), notice: "グループに参加しました。"
  else
    redirect_to group_path(@group), alert: "グループの最大人数に達しているため、参加できません。"
  end
end

def leave
  @group = Group.find(params[:id])

  if @group.users.include?(current_user)
    @group.users.delete(current_user)
    flash[:notice] = "グループから退出しました。"
  else
    flash[:alert] = "グループから退出できませんでした。"
  end

  redirect_to group_path(@group)
end


  def user_count
    group = Group.find(params[:id])
    user_count = group.users.count + 1 

    render json: { user_count: user_count }
  end

  def user_list
    group = Group.find(params[:id])
    users = group.users

    render json: { user_list: users.map { |user| { id: user.id, name: user.name } } }
  end
  

def show
  @group = Group.find(params[:id])
  @tags = @group.tags

  # ユーザーがグループに参加しているかどうかを確認
  if @group.users.include?(current_user) || @group.owner == current_user

  else
    flash[:error] = "このグループに参加していないため、アクセスできません。"
    redirect_to root_path
  end
end

  def new
    @group = Group.new
  end

def create
  @group = Group.new(group_params)
  @group.owner_id = current_user.id

  # タグ情報を取得し、関連付け
  tag_ids = params[:group][:tag_ids]
  @group.tags = Tag.where(id: tag_ids) if tag_ids.present?

  if @group.save
    redirect_to group_path(@group), notice: 'グループが作成されました'
  else
    render :new
  end
end


def update
  @group = Group.find(params[:id])

  if @group.update(group_params)
    redirect_to group_path(@group), notice: 'グループが更新されました'
  else
    render :edit
  end
end

def destroy
  @group = Group.find(params[:id])

  if @group.owner == current_user
    @group.destroy
    redirect_to root_path, notice: 'グループが削除されました'
  else
    redirect_to root_path, alert: 'グループを削除する権限がありません'
  end
end


  def edit
    @group = Group.find(params[:id])
  end

  private
      #ユーザーがグループを所持しているか判定
  def check_user_can_create_only_one_group
    if current_user.owned_groups.any?
      redirect_to root_path, alert: "既にグループを作成済みです"
    end
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to root_path
    end
  end

  def group_params
    params.require(:group).permit(:introduction, :game_title, :max_users, tag_ids: [])
  end

end
