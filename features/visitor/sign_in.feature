Feature: Sign in

  In order to access my account
  As a visitor
  I want to be able to sign in

  Background:
    Given the following user exists:
      | name | email           |
      | Bob  | bob@example.com |

  Scenario: Signing in successfully
    When I sign in with "bob@example.com" and "test"
    Then I should be signed in as "Bob"
    And I should see the API tokens for the "Bob" account

  Scenario: Signing in with invalid credentials
    When I sign in with "bob@example.com" and "wrong"
    Then I should be told my credentials are invalid

  Scenario: Signing in with invalid information
    When I sign in with "" and ""
    Then I should be told my credentials are invalid
