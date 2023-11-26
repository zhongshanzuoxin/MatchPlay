class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_tag, only: [:destroy]
  include Pagy::Backend

  # タグ一覧表示
  def index
    load_tags # タグとページネーション情報をロード
  end

  # 新規タグ作成アクション
  def create
    @tag = Tag.new(tag_params) 
    if @tag.save
      redirect_to admin_tags_path, notice: 'タグが作成されました'
    else
      load_tags
      flash.now[:alert] = 'タグの作成に失敗しました'
      render :index
    end
  end

  # タグ削除アクション
  def destroy
    if @tag.destroy
      redirect_to admin_tags_path, notice: 'タグが削除されました'
    else
      redirect_to admin_tags_path, alert: 'タグの削除に失敗しました'
    end
  end

  private


  def set_tag
    @tag = Tag.find_by(id: params[:id])
    redirect_to admin_tags_path, alert: 'タグが見つかりません' unless @tag
  end

  # タグ一覧とページネーション情報のロード
  def load_tags
    @pagy, @tags = pagy(Tag.all, items: 10)
  end


  def tag_params
    params.require(:tag).permit(:tag_name)
  end
end
