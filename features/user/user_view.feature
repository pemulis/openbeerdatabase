Feature: Viewing a user

  In order to obtain my API token
  As a user
  I want to be able to view my account

  Background:
    Given I sign up as "Bob"

  Scenario: Viewing the current user
    When I go to the account page for "Bob"
    Then I should see the API tokens for the "Bob" account

  Scenario: Viewing another user
    Given a user exists with a name of "Sue"
    When I go to the account page for "Sue"
    Then I should not see the API tokens for the "Sue" account
