# lib/tasks/scheduler.rake
namespace :scheduler do
  desc "This task runs daily to perform scheduled tasks"
  task close_and_settle_auctions: :environment do
    puts "Checking for unsettled auctions at #{Time.zone.now}..."
    # Add your logic here
    # Example: User.send_daily_notifications
    AuctionItem.cron_close_auctions!
    puts "Auction settlements complete."
  end
end
