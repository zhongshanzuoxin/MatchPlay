class Public::MessagesController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    @message = @group.messages.create(message_params)
    ChatChannel.broadcast_to(@group, @message)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end 
end 
