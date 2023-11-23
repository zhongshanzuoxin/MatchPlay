class Public::RelationshipsController < ApplicationController

  def block
    user = User.find_by(id: params[:id])
    if user && current_user.block(user.id)
      flash[:notice] = "ブロックしました。"
    else
      flash[:alert] = "ブロックに失敗しました。"
    end

    respond_to do |format|
      format.html { redirect_to user_path(user || current_user) }
      format.js
    end
  end


  def unblock
    user = User.find_by(id: params[:id])
    if user && current_user.unblock(user.id)
      flash[:notice] = "ブロックを解除しました。"
    else
      flash[:alert] = "ブロック解除に失敗しました。"
    end

    respond_to do |format|
      format.html { redirect_to user_path(user || current_user) }
      format.js
    end
  end

end
