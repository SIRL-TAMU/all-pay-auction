# all-pay-auction
All_Pay_Auction implements an all-pay auction where every bidder pays their bid, regardless of winning. The highest bidder wins, but all participants pay their bids. The seller sets a closing date for the auction, after which no bids are accepted. At settlement, the auctioneer collects payments from all bidders.

# Documents
[Team Working Agreement](/documentation/TWA.md)

# Web Application Link
Deploy to heroku: https://all-pay-auction-6236fe9c4614.herokuapp.com/

# Code Quality and Test Coverage Reports
Code climate: https://codeclimate.com/github/SIRL-TAMU/all-pay-auction

# Test Coverage Status

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



