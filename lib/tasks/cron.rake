namespace :cron do
  desc "Run the test cron job"
  task test_cron_job: :environment do
    AuctionItem.test_cron_job
  end
end
