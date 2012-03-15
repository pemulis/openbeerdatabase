Feature: Create a beer

  In order to build a database of beers
  As an API client
  I want to be able to create beers via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Creating a beer with a private token
    Given the following brewery exists:
      | user                  | name  |
      | private_token: x1y2z3 | Abita |
    When I create the following beer via the API for the "Abita" brewery using the "x1y2z3" token:
      | name  | description | abv |
      | Amber | Common.     | 4.5 |
    Then I should receive a 201 response
    And the Location header should be set to the API beer page for "Amber"
    And the following beer should exist:
      | user                  | brewery     | name  | description | abv |
      | private_token: x1y2z3 | name: Abita | Amber | Common.     | 4.5 |

  Scenario: Creating a beer with a public token
    Given the following brewery exists:
      | user                 | name  |
      | public_token: a1b2c3 | Abita |
    When I create the following beer via the API for the "Abita" brewery using the "a1b2c3" token:
      | name  | description | abv |
      | Amber | Common.     | 4.5 |
    Then I should receive a 401 response
    And the API user with the public token "a1b2c3" should have 0 beers

  Scenario: Creating a beer with a brewery not owned by the requesting API client
    Given a brewery exists with a name of "Southern Tier"
    When I create the following beer via the API for the "Southern Tier" brewery using the "x1y2z3" token:
      | name     |
      | Pumpking |
    Then I should receive a 400 response
    And the API user with the private token "x1y2z3" should have 0 beers

  Scenario: Creating a beer with validation errors
    Given a brewery exists with a name of "Southern Tier"
    When I create the following beer via the API for the "Southern Tier" brewery using the "x1y2z3" token:
      | name | description |
      |      |             |
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "brewery_id"  : ["can't be blank"],
            "name"        : ["can't be blank"],
            "description" : ["can't be blank"],
            "abv"         : ["can't be blank", "is not a number"]
          }
        }
      """

  Scenario Outline:
    When I send an API POST request to /v1/beers.<format>?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                              | token  | status | format |
    | { "beer" : { "name" : "Amber" } } | a1b2c3 | 401    | json   |
    | { "beer" : {} }                   | a1b2c3 | 401    | json   |
    | {}                                | a1b2c3 | 401    | json   |
    |                                   | a1b2c3 | 401    | json   |
    | { "beer" : { "name" : "Amber" } } | a1b2c3 | 401    | xml    |
    | { "beer" : {} }                   | x1y2z3 | 400    | json   |
    | {}                                | x1y2z3 | 400    | json   |
    |                                   | x1y2z3 | 400    | json   |
    | { "beer" : { "name" : "Amber" } } | x1y2z3 | 406    | xml    |
    | { "beer" : { "name" : "Amber" } } |        | 401    | json   |
    | { "beer" : {} }                   |        | 401    | json   |
    | {}                                |        | 401    | json   |
    |                                   |        | 401    | json   |
    | { "beer" : { "name" : "Amber" } } |        | 401    | xml    |
