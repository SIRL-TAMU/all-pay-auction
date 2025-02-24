# frozen_string_literal: true

# Helper methods for Auction Items
module AuctionItemsHelper
  def auction_status(item)
    now = Time.zone.now
    if item.opening_date > now
      [ "upcoming", "Opens on #{item.opening_date.strftime('%b %d, %Y')}" ]
    elsif item.closing_date < now
      [ "closed", "Closed on #{item.closing_date.strftime('%b %d, %Y')}" ]
    else
      remaining_time = item.closing_date - now
      days = (remaining_time / 1.day).to_i
      hours = ((remaining_time % 1.day) / 1.hour).to_i
      minutes = ((remaining_time % 1.hour) / 1.minute).to_i
      [ "active", "Closing in #{days}d #{hours}h #{minutes}m" ]
    end
  end
end
