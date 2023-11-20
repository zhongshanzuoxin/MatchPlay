class Admin::IconsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin
  include Pagy::Backend

  # アイコンのアップロードフォームを表示
  def new
  end

  # アイコンの一覧を表示
  def index
    @pagy, @icons = pagy(@admin.image.blobs, items: 6)
  end

  # アイコンをアップロード
  def create
    @admin.image.attach(icon_params[:image]) 
    if @admin.save
      redirect_to new_admin_icon_path, notice: "アイコンがアップロードされました。"
    else
      redirect_to new_admin_icon_path, alert: error_messages 
    end
  end

  # アイコンを削除
  def destroy
    @icon = ActiveStorage::Attachment.find(params[:id])
    @icon.purge
    redirect_to admin_icons_path, notice: 'アイコンが削除されました。'
  end

  private

  # 現在の管理者をセット
  def set_admin
    @admin = current_admin
  end

  # アイコンのパラメータを許可
  def icon_params
    params.require(:admin).permit(:image)
  end

  # エラーメッセージを取得
  def error_messages
    @admin.errors.full_messages.join(', ')
  end
end
