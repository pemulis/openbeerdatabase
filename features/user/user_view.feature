Feature: Viewing a user

  In order to obtain my API token
  As a user
  I want to be able to view my account

  Background:
    Given I am signed in as "Bob"

  Scenario: Viewing the current user
    When I go to the account page for "Bob"
    Then I should be on the account page for "Bob"
    And I should see the API tokens for the "Bob" account

  Scenario: Viewing another user
    Given a user exists with a name of "Sue"
    When I go to the account page for "Sue"
    Then I should be on the homepage
