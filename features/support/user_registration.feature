Feature: User Registration 

    As a new user,
    I want to create a buyer account,
    So that I can log in and view auction items available for purchase.

Scenario: Buyer Successful Registration
    Given I am on the Registration page
    When I fill in the registration form with valid details
    And I submit the form
    Then I should be logged in

