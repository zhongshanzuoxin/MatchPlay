class Public::BlockUsersController < ApplicationController
  before_action :authenticate_user!
  def index
  end
  
  def create
    @user_to_block = User.find(params[:user_id])
    current_user.block!(@user_to_block)
    redirect_to @user_to_block, notice: "ユーザーをブロックしました"
  end 
  
  def destroy
    @user_to_unblock = User.find(params[:user_id])
    current_user.unblock!(@user_to_unblock)
    redirect_to @user_to_unblock, notice: "ユーザーのブロックを解除しました"
  end 
end
