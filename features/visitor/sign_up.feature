Feature: Sign up

  In order to find and create records via the API
  As a visitor
  I want to be able to sign up

  Background:
    Given I am on the homepage
    And I follow "Sign up for an API token."

  Scenario: Signing up successfully
    When I fill in "Name" with "Bob"
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I fill in "Password Confirmation" with "test"
    And I press "Sign Up"
    Then I should be on the account page for "Bob"
    And I should see the API tokens for the "Bob" account

  Scenario: Signing up with invalid information
    When I press "Sign Up"
    Then I should see "can't be blank"
