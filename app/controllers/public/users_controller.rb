class Public::UsersController < ApplicationController
  def show
  end
  
  def blocked_users
    @blocked_users = current_user.blocked_users
  end 
end
