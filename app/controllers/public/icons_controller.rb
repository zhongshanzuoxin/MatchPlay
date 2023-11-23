class Public::IconsController < ApplicationController
  before_action :set_user, only: [:index, :update]
  include Pagy::Backend

  # ユーザーアイコン一覧を表示
  def index
    @pagy, @icons = pagy(ActiveStorage::Attachment.includes(:blob).where(record_type: 'Admin', name: 'image'), items: 4)
  end

  # ユーザーアイコンを更新
  def update
    # 選択されたアイコンを取得
    @icon = ActiveStorage::Attachment.find_by(id: icon_params[:selected_icon_id])

    # アイコンが存在すれば更新処理を行う
    if @icon
      ActiveRecord::Base.transaction do
        @user.image.attach(@icon.blob)

        if @user.save
          redirect_to @user, notice: 'アイコンが更新されました。'
        else
          redirect_to icon_index_user_path(@user), alert: 'アイコンの更新に失敗しました。'
        end
      end
    else
      redirect_to icon_index_user_path(@user), alert: '選択されたアイコンが見つかりませんでした。'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end


  def icon_params
    params.permit(:selected_icon_id)
  end
end
