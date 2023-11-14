class Public::MessagesController < ApplicationController
  protect_from_forgery except: :index 
  
def create
  @group = Group.find(params[:group_id])
  @message = @group.messages.new(message_params)
  @message.user = current_user

  if @message.save
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  else
    respond_to do |format|
      format.html { redirect_to @group, alert: "メッセージの送信に失敗しました。" }
      format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
    end
  end
end


  def index
    @group = Group.find(params[:group_id])
    @messages = @group.messages.order(created_at: :desc).limit(10).reverse
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
