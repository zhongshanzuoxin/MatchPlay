class Public::GroupsController < ApplicationController
  before_action :check_if_user_has_group, only: [:new]

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

    if selected_tags.present?
      groups = groups.where(group_tags: { tag_id: selected_tags })
    end

    if game_title.present?
      groups = groups.where("LOWER(groups.game_title) LIKE LOWER(?)", "%#{ActiveRecord::Base.sanitize_sql_like(game_title)}%")
    end
    @groups = selected_tags.present? || game_title.present? ? groups.distinct : []
    @selected_tags = Tag.where(id: selected_tags)
    @other_tags = Tag.joins(:group_tags).where.not(id: selected_tags).distinct
  end

  def show
    @group = Group.find(params[:id])
    @messages = Message.all
  end

  def new
    @group = Group.new
  end

def create
  if current_user.group.present?
    redirect_to root_path, alert: '既にグループを作成しています'
  else
    @group = current_user.build_group(group_params)

    # タグ情報を取得し、関連付け
    tag_ids = params[:group][:tag_ids]
    @group.tags = Tag.where(id: tag_ids) if tag_ids.present?

    if @group.save
      redirect_to root_path, notice: 'グループが作成されました'
    else
      render :new
    end
  end
end

def update
  @group = Group.find(params[:id])

  if @group.update(group_params)
    redirect_to root_path, notice: 'グループが更新されました'
  else
    render :edit
  end
end

def destroy
  @group = Group.find(params[:id])

  if @group.user == current_user
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
  
  def check_if_user_has_group
    if current_user.group.present?
      redirect_to root_path, alert: '既にグループを作成しています'
    end
  end

  def group_params
    params.require(:group).permit(:introduction, :game_title, tag_ids: [])
  end

end
