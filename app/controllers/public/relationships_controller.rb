class Public::RelationshipsController < ApplicationController

  def block
    user = User.find(params[:id])
    current_user.block(user.id)
    respond_to do |format|
      format.html { redirect_to user_path(user) }
      format.js
    end
  end

  def unblock
    user = User.find(params[:id])
    current_user.unblock(user.id)
    respond_to do |format|
      format.html { redirect_to user_path(user) }
      format.js
    end
  end

end
