# frozen_string_literal: true

# Represents an auction item listed by a seller
class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids, dependent: :destroy
  belongs_to :winning_buyer, class_name 'Buyer', optional: true

  def max_bid
    bids.maximum(:amount) || self[:curr_max_bid] || 0 # here max_bid could be starting price
  end

  def total_bids
    bids.count
  end

  # Calculate bid pool by summing each user's highest bid
  def bid_pool
    bids.group(:buyer_id).maximum(:amount).values.sum || 0
  end

  def latest_bids(limit = 4)
    bids.includes(:buyer).order(created_at: :desc).limit(limit)
  end

  def winning_bid
    return nil unless closed?

    bids.includes(:buyer).order(amount: :desc).first
  end

  def status_text
    now = Time.zone.now
    if opening_date > now
      "Opens on #{opening_date.strftime('%b %d, %Y')}"
    elsif closing_date > now
      "Closing in #{time_remaining}"
    else
      "Closed on #{closing_date.strftime('%b %d, %Y')}"
    end
  end

  def time_remaining
    remaining_time = closing_date - Time.zone.now
    days = (remaining_time / 1.day).to_i
    hours = ((remaining_time % 1.day) / 1.hour).to_i
    minutes = ((remaining_time % 1.hour) / 1.minute).to_i

    if days.positive?
      "#{days}d #{hours}h #{minutes}m"
    elsif hours.positive?
      "#{hours}h #{minutes}m"
    else
      "#{minutes}m"
    end
  end

  def active?
    Time.zone.now.between?(opening_date, closing_date)
  end

  def closed?
    Time.zone.now > closing_date
  end

  def upcoming?
    Time.zone.now < opening_date
  end
end
