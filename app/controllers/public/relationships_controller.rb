class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # ユーザーをブロックするアクション
  def block

    user = User.find_by(id: params[:id])

    # 対象のユーザーが存在し、現在のユーザーがブロックに成功した場合
    if user && current_user.block(user.id)
      flash[:notice] = "ブロックしました。"
    else
      flash[:alert] = "ブロックに失敗しました。"
    end

    # レスポンス形式に応じた処理を行う
    respond_to do |format|
      format.html { redirect_to user_path(user || current_user) }
      format.js
    end
  end

  # ユーザーのブロックを解除するアクション
  def unblock

    user = User.find_by(id: params[:id])

    # 対象のユーザーが存在し、現在のユーザーがブロック解除に成功した場合
    if user && current_user.unblock(user.id)
      flash[:notice] = "ブロックを解除しました。"
    else
      flash[:alert] = "ブロック解除に失敗しました。"
    end

    # レスポンス形式に応じた処理を行う
    respond_to do |format|
      format.html { redirect_to user_path(user || current_user) }
      format.js
    end
  end

end
