Feature: Delete a beer

  In order to remove unwanted beers
  As an API client
  I want to be able to delete beers via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Deleting a beer with a private token
    Given the following beer exists:
      | id | user                  |
      | 1  | private_token: x1y2z3 |
    When I send an API DELETE request to /v1/beers/1?token=x1y2z3
    Then I should receive a 200 response
    And the API user with the private token "x1y2z3" should have 0 beers

  Scenario: Deleting a beer with a public token
    Given the following beer exists:
      | id | user                 |
      | 1  | public_token: a1b2c3 |
    When I send an API DELETE request to /v1/beers/1?token=a1b2c3
    Then I should receive a 401 response
    And the API user with the public token "a1b2c3" should have 1 beer

  Scenario: Deleting a beer, not owned by the requesting API client
    Given the following beer exists:
      | id | user                  |
      | 1  | private_token: d4e5f6 |
    When I send an API DELETE request to /v1/beers/1?token=x1y2z3
    Then I should receive a 401 response
    And the API user with the private token "d4e5f6" should have 1 beer

  Scenario: Deleting a beer, not owned by an API client
    Given the following beer exists:
      | id | user | name     |
      | 1  |      | Pumpking |
    When I send an API DELETE request to /v1/beers/1?token=a1b2c3
    Then I should receive a 401 response
    And the following beer should exist:
      | id | name     |
      | 1  | Pumpking |

  Scenario: Deleting a beer, that does not exist
    When I send an API DELETE request to /v1/beers/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Deleting a beer, without an API token
    When I send an API DELETE request to /v1/beers/1.json
    Then I should receive a 401 response
