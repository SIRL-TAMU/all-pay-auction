Feature: Seller Login
    As a seller,
    I want to login a seller account,
    So that I can access my seller dashboard and participate in auction.

Scenario: Successful Seller Login
    Given I am on the Seller login page
    When I fill in the Seller login form with valid details
    And I submit the Seller login form
    Then I should be logged in and landed in the Seller dashboard