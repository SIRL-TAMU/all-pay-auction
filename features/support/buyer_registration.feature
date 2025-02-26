Feature: Buyer Registration 

    As a new buyer,
    I want to create a buyer account,
    So that I can log in and view auction items available for purchase.

Scenario: Successful Buyer Registration
    Given I am on the Buyer registration page
    When I fill in the Buyer registration form with valid details
    And I submit the Buyer registration form
    Then I should be logged in and redirected to the Buyer dashboard

