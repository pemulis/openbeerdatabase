Feature: Sign in

  In order to access my account
  As a visitor
  I want to be able to sign in

  Background:
    Given the following user exists:
      | name | email           |
      | Bob  | bob@example.com |
    And I am on the homepage
    And I follow "Sign in"

  Scenario: Signing in successfully
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "test"
    And I press "Sign In"
    Then I should be on the account page for "Bob"
    And I should see "Signed in as Bob."
    And I should see the API tokens for the "Bob" account

  Scenario: Signing in with invalid credentials
    When I fill in "E-mail" with "bob@example.com"
    And I fill in "Password" with "wrong"
    And I press "Sign In"
    Then I should see "E-mail or password is incorrect. Please try again."

  Scenario: Signing in with invalid information
    When I press "Sign In"
    Then I should see "E-mail or password is incorrect. Please try again."
