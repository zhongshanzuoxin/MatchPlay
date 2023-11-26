class Public::MessagesController < ApplicationController
  # CSRF保護を有効にし、indexアクションを除外する
  protect_from_forgery except: :index

  # メッセージを作成するアクション
  def create
    @group = Group.find(params[:group_id])

    # 新しいメッセージを作成し、ユーザーを関連付け
    @message = @group.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to @group, notice: "メッセージを送信しました" }
        format.json 
      end
    else
      respond_to do |format|
        format.html { redirect_to @group, alert: "メッセージの送信に失敗しました" }
        format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # グループのメッセージ一覧を表示するアクション
  def index
    @group = Group.find(params[:group_id])

    # 最新のメッセージ10件を取得し、時系列順に逆順に表示します
    @messages = @group.messages.order(created_at: :desc).reverse_order
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
