Feature: Seller Registration 

    As a new seller,
    I want to create a seller account,
    So that I can log in and sell items.

Scenario: Successful Seller Registration
    Given I am on the Seller registration page
    When I fill in the Seller registration form with valid details
    And I submit the Seller registration form
    Then I should be logged in and redirected to the Seller dashboard