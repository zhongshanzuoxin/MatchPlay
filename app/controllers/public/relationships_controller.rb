class Public::RelationshipsController < ApplicationController
  
  def block
   current_user.block(params[:id])
   redirect_to root_path
  end

  def unblock
   current_user.unblock(params[:id])
   redirect_to root_path
  end

end
