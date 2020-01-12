class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params['room_id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create(data)
  	Message.create(user_id: data['current_user_id'],room_id: params['room_id'],content: data['data'])
    ActionCable.server.broadcast "chat_channel_#{params['room_id']}", data
  end
end
