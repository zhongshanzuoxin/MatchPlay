class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "group_#{params[:group_id]}_chat" # グループごとに別のチャンネルを使う
  end

  def speak(data)
    Chat.create!(message: deta['message'], user: current_user, group_id: params[:group_id])
  end
end