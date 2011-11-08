Feature: Sign up

  In order to find and create records via the API
  As a visitor
  I want to be able to sign up

  Scenario: Signing up successfully
    Given I sign up as "Bob"
    Then I should be signed in as "Bob"
    And I should see the API tokens for the "Bob" account

  Scenario: Signing up with invalid information
    Given I sign up with invalid information
    Then I should be told to enter valid information
