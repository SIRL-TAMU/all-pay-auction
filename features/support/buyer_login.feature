Feature: Buyer Login
    As a buyer,
    I want to login a buyer account,
    So that I can access my buyer dashboard and participate in auction.

Scenario: Successful Buyer Login
    Given I am on the Buyer login page
    When I fill in the Buyer login form with valid details
    And I submit the Buyer login form
    Then I should be logged in and landed in the Buyer dashboard