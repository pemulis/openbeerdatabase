Feature: Delete a brewery

  In order to remove unwanted breweries
  As an API client
  I want to be able to delete breweries via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Deleting a brewery with a private token
    Given the following brewery exists:
      | id | user                  |
      | 1  | private_token: x1y2z3 |
    When I send an API DELETE request to /v1/breweries/1?token=x1y2z3
    Then I should receive a 200 response
    And the API user with the private token "x1y2z3" should have 0 breweries

  Scenario: Deleting a brewery with a public token
    Given the following brewery exists:
      | id | user                 |
      | 1  | public_token: a1b2c3 |
    When I send an API DELETE request to /v1/breweries/1?token=a1b2c3
    Then I should receive a 401 response
    And the API user with the public token "a1b2c3" should have 1 brewery

  Scenario: Deleting a brewery not owned by the requesting API client as an administrator
     Given the following brewery exists:
      | id | user                  |
      | 1  | private_token: x1y2z3 |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I send an API DELETE request to /v1/breweries/1?token=e1f2g3
    Then I should receive a 200 response
    And the API user with the private token "x1y2z3" should have 0 breweries

  Scenario: Deleting a brewery not owned by the requesting API client
    Given the following brewery exists:
      | id | user                  |
      | 1  | private_token: d4e5f6 |
    When I send an API DELETE request to /v1/breweries/1?token=a1b2c3
    Then I should receive a 401 response
    And the API user with the private token "d4e5f6" should have 1 brewery

  Scenario: Deleting a brewery not owned by an API client
    Given the following brewery exists:
      | id | user | name  |
      | 1  |      | Abita |
    When I send an API DELETE request to /v1/breweries/1?token=a1b2c3
    Then I should receive a 401 response
    And the following brewery should exist:
      | id | name  |
      | 1  | Abita |

  Scenario: Deleting a brewery with beers
    Given the following brewery exists:
      | id | user                  |
      | 1  | private_token: x1y2z3 |
    And the following beer exists:
      | brewery     | user                  |
      | name: Abita | private_token: x1y2z3 |
    When I send an API DELETE request to /v1/breweries/1?token=x1y2z3
    Then I should receive a 400 response
    And the API user with the private token "x1y2z3" should have 1 beer
    And the API user with the private token "x1y2z3" should have 1 brewery

  Scenario: Deleting a brewery that does not exist
    When I send an API DELETE request to /v1/breweries/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Deleting a brewery without an API token
    When I send an API DELETE request to /v1/breweries/1.json
    Then I should receive a 401 response
