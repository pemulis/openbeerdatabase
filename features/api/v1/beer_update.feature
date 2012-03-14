Feature: Update a beer

  In order to change beer information
  As an API client
  I want to be able to update beers via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Updating a beer with a private token
    Given the following beer exists:
      | id | user                  | name     |
      | 1  | private_token: x1y2z3 | Pumpking |
    When I update the "Pumpking" beer via the API using the "x1y2z3" token:
      | name  |
      | Amber |
    Then I should receive a 200 response
    And the following beer should exist:
      | user                  | name  |
      | private_token: x1y2z3 | Amber |

  Scenario: Updating a beer with a public token
    Given the following beer exists:
      | id | user                 | name     |
      | 1  | public_token: a1b2c3 | Pumpking |
    When I update the "Pumpking" beer via the API using the "a1b2c3" token:
      | name  |
      | Amber |
    Then I should receive a 401 response
    And the following beer should exist:
      | user                 | name     |
      | public_token: a1b2c3 | Pumpking |

  Scenario: Updating a beer not owned by the requesting API client as an administrator
     Given the following beer exists:
      | id | user                  | name     |
      | 1  | private_token: x1y2z3 | Pumpking |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Pumpking" beer via the API using the "e1f2g3" token:
      | name  |
      | Amber |
    Then I should receive a 200 response
    And the following beer should exist:
      | user                  | name  |
      | private_token: x1y2z3 | Amber |

  Scenario: Updating a beer not owned by the requesting API client
    Given the following beer exists:
      | id | user                  | name     |
      | 1  | private_token: d4e5f6 | Pumpking |
    When I update the "Pumpking" beer via the API using the "a1b2c3" token:
      | name  |
      | Amber |
    Then I should receive a 401 response
    And the following beer should exist:
      | user                  | name     |
      | private_token: d4e5f6 | Pumpking |

  Scenario: Updating a beer not owned by an API client
    Given the following beer exists:
      | id | user | name     |
      | 1  |      | Pumpking |
    When I update the "Pumpking" beer via the API using the "a1b2c3" token:
      | name  |
      | Amber |
    Then I should receive a 401 response
    And the following beer should exist:
      | id | name     |
      | 1  | Pumpking |

  Scenario: Updating a beer not owned by an API client as an administrator
    Given the following beer exists:
      | id | user | name     |
      | 1  |      | Pumpking |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Pumpking" beer via the API using the "e1f2g3" token:
      | name  |
      | Amber |
    Then I should receive a 200 response
    And the following beer should exist:
      | id | name  |
      | 1  | Amber |

  Scenario: Updating a beer with validation errors
    Given the following beer exists:
      | id | user                  | name     |
      | 1  | private_token: x1y2z3 | Pumpking |
    When I update the "Pumpking" beer via the API using the "x1y2z3" token:
      | name | description |
      |      |             |
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "name"        : ["can't be blank"],
            "description" : ["can't be blank"]
          }
        }
      """

  Scenario: Updating a beer that does not exist
    When I send an API PUT request to /v1/beers/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Updating a beer without an API token
    When I send an API PUT request to /v1/beers/1.json
    Then I should receive a 401 response
