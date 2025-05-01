# All Pay Auction
All Pay Auction implements an all-pay auction where every bidder pays their bid, regardless of winning. The highest bidder wins, but all participants pay their bids. The seller sets a closing date for the auction, after which no bids are accepted. At settlement, the auctioneer collects payments from all bidders. **This application is currently in active development and not yet production-ready.**

## Current State (Debug Mode)

⚠️ **The application is currently configured for debugging and testing purposes. Do not deploy to production without addressing the following:**

- **Manual Auction Settlement**: Sellers can manually settle auctions. **This feature must be disabled in production** to ensure automated, time-based settlement.
- **Stripe Sandbox Keys**: The Stripe API keys are configured for the sandbox environment. Replace with live keys for production use.

---

## Prerequisites

Before deployment, ensure the following are installed:
- Ruby 3.3
- Rails 7.2
- PostgreSQL
- Git
- Docker (optional, for containerized deployment)
- Heroku CLI (for Heroku deployment)

## Deployment

1. **Create a Heroku App**
```bash
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh
heroku create your-app-name
```

2. **Install Required Add-Ons**
```bash
heroku addons:create heroku-postgresql:hobby-dev
heroku addons:create scheduler:standard
heroku addons:create heroku-redis:mini
```

3. **Set Environment Variables**
```bash
heroku config:set RAILS_ENV=production \
  STRIPE_PUBLISHABLE_KEY=your_key \
  STRIPE_SECRET_KEY=your_key \
  STRIPE_WEBHOOK_SECRET=your_key \
  STRIPE_PROD_WEBHOOK_SECRET=your_key \
  RAILS_ENV=production \
  AWS_ACCESS_KEY_ID=your_aws_key \
  AWS_SECRET_ACCESS_KEY=your_aws_secret \
  GOOGLE_SECRET_ACCESS_KEY=your_google_secret \
  GOOGLE_CLIENT_ID=your_google_id
```
4. **Deploy Code To Heroku**
```bash
git push heroku main
```

5. **Database Migrations**
```bash
heroku run rails db:migrate
```

6. **Create cron job for auction settlement**
- Go to the Heroku application dashboard
- Click on resources, and then navigate to Add-on Services
- Click on Heroku Scheduler, and add job
- Choose a proper interval according to your scheduler plan
- Add the command `rake scheduler:close_and_settle_auctions`

## Tech Stack
- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Ruby on Rails 7.2
- **Language**: Ruby 3.3
- **Database**: PostgreSQL
- **Version Control**: Git/GitHub
- **Containerization**: Docker

## Environment Variables

```bash
# Required for production
STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET
STRIPE_PROD_WEBHOOK_SECRET
RAILS_ENV=production
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
GOOGLE_SECRET_ACCESS_KEY
GOOGLE_CLIENT_ID
```

## Documents
[Team Working Agreement](/documentation/TWA.md)

## Web Application Link
Deploy to heroku: https://all-pay-auction3-478f271f12bd.herokuapp.com/

Note: The current heroku deployment is deployed using the `test-google-2` branch

## Code Quality and Test Coverage Reports
Code climate: https://codeclimate.com/github/SIRL-TAMU/all-pay-auction

## Test Coverage Status

| Test                      | Status            |                 
| -----------               | -----------       |
| BDD (`cucumber`)          | Work in progress (adding more tests)  |           
| TDD (`rspec`)             | Work in progress (adding more tests) |           
| Code style (`rubocop`)    | 100%              |           
| Coverage report           | 100%              |           

**Update (2/24):** Cucumber rspec bugs fixed. Currently working on adding more tests.

- TDD tests: run `bundle exec cucumber` in docker container app-1

- BDD tests: run `bundle exec rspec` in docker container app-1

- Test coverage run `rails test` in docker container app-1

- Coverage report generated in `coverage/index.html` in all-pay-auction repository.

- Code style Rubocop: run `rubocop` in docker container app-1



