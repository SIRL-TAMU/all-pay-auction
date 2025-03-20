Feature: Close Auction
  As an auction system
  I want to close auctions
  So that the winning buyer is notified and the auction is archived

  Scenario: Close an individual auction
    Given there is an auction item with bids and closing date has passed
    And the auction item is not archived or closed
    When I close the auction
    Then the auction should be archived
    And the winning buyer should be set with an updated asset balance
    And the seller should have an updated liquid balance

  Scenario: Close all auctions via cron job
    Given there are multiple auction items with bids and closing date has passed
    And some auctions are not archived or closed
    When I run the cron job to close auctions
    Then all auctions should be archived
    And the winning buyers should be set with an updated asset balance
    And the sellers should have an updated liquid balance
