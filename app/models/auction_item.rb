# frozen_string_literal: true

# Represents an auction item listed by a seller
class AuctionItem < ApplicationRecord
  belongs_to :seller
  has_many :bids, dependent: :destroy
  has_many :buyers, through: :bids
  belongs_to :winning_buyer, class_name: "Buyer", optional: true
  has_many_attached :images
  enum item_type: { currency: 0, physical: 1 }

  # validates :opening_date, presence: true, comparison: { greater_than_or_equal_to: -> { Time.zone.now } }
  # validates :closing_date, presence: true, comparison: { greater_than: :opening_date }

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
    elsif minutes.positive?
      "#{minutes}m"
    else
      "0m"
    end
  end

  def archived?
    is_archived
  end

  def active?
    return Time.zone.now.between?(opening_date, closing_date) unless archived?
    !archived?
  end

  def closed?
    return Time.zone.now > closing_date unless archived?
    archived?
  end

  def upcoming?
    return Time.zone.now < opening_date unless is_archived
    !archived?
  end

  def self.test_cron_job
    auction_items = AuctionItem.all
    File.write("test_cron.txt", "#{Time.zone.now}\n", mode: "a")
    auction_items.each do |auction_item|
      File.write("test_cron.txt", "#{auction_item.name}\n", mode: "a")
    end
    File.write("test_cron.txt", "\n", mode: "a")
  end

  def close_auction!
    if archived? || ! closed?
      puts "Auction #{name} is either settled or closed."
      return
    end

    puts "Auction #{name} has closed and now will be settled."
    winning_buyer = winning_bid.buyer

    # Updates itself, the winning buyer, and the seller
    update!(winning_buyer_id: winning_buyer.id, is_archived: true)
    if physical?
      # Keep current logic for physical items
      winning_buyer.update!(asset_balance: winning_buyer.asset_balance + innate_value)
    elsif currency?
      # For currency items, transfer value into the buyer's liquid_balance instead
      winning_buyer.update!(liquid_balance: winning_buyer.liquid_balance + innate_value)
    end

    # Add notification logic if we can
    puts "Notification logic NOT implemented yet."

    puts "Auction #{name} has been settled."
  end

  def self.cron_close_auctions!
    auction_items = AuctionItem.all
    auction_items.each do |auction_item|
      auction_item.close_auction!
    end
  end
end
