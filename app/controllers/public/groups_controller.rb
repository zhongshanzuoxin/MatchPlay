class Public::GroupsController < ApplicationController

  def index
    @groups = Group.all
  end

  def search
    @groups = Group.all
    tag_params = [params[:tag1], params[:tag2], params[:tag3], params[:tag4]]

    tag_params.each do |tag|
    if tag.present?
      @groups = @groups.where(tag: tag)
    end
  end

    if params[:game_title].present?
      @groups = @groups.where("game_title ILIKE ?", "%#{params[:game_title]}%")
    end
  end

  def show
    @group = Group.find(params[:id])
    @messages = @group.chats
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

  def edit
  end

  private

def group_params
  params.require(:group).permit(:introduction, :game_title, tag_ids: [])
end

end
