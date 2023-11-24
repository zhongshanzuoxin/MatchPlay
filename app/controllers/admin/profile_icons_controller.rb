class Admin::ProfileIconsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_profile_icon, only: [:destroy]
  include Pagy::Backend

  # アイコン一覧表示アクション
  def index
    @pagy, @profile_icons = pagy(ProfileIcon.all, items: 4)
  end

  # 新しいアイコンのアップロード画面を表示するアクション
  def new
  end

  # アイコンをアップロードするアクション
  def create
    @profile_icon = ProfileIcon.new(profile_icon_params)
    if @profile_icon.save
      redirect_to new_admin_profile_icon_path, notice: 'アイコンがアップロードされました'
    else
      render :new
    end
  end

  # アイコンを削除するアクション
  def destroy
    @profile_icon.destroy
    redirect_to admin_profile_icons_path, notice: 'アイコンが削除されました'
  end

  private

  # destroy アクションで使用するプライベートメソッド
  def set_profile_icon
    @profile_icon = ProfileIcon.find(params[:id])
  end

  def profile_icon_params
    params.require(:profile_icon).permit(:image)
  end
end
