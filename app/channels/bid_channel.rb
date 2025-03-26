class BidChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bids_#{params[:auction_item_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
