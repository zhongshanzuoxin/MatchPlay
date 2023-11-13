class Public::RelationshipsController < ApplicationController
  
  def block
    user = User.find(params[:id]) # ブロック対象のユーザーを取得
    current_user.block(user.id) # 現在のユーザーでブロックを実行
    redirect_to user_path(user) # ブロック後にユーザーの詳細画面にリダイレクト
  end

  def unblock
    user = User.find(params[:id]) # ブロック解除対象のユーザーを取得
    current_user.unblock(user.id) # 現在のユーザーでブロック解除を実行
    redirect_to user_path(user) # ブロック解除後にユーザーの詳細画面にリダイレクト
  end

end
