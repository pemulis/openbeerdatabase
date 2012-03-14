Feature: Update a brewery

  In order to change brewery information
  As an API client
  I want to be able to update breweries via the API

  Background:
    Given the following user exists:
      | public_token | private_token |
      | a1b2c3       | x1y2z3        |

  Scenario: Updating a brewery with a private token
    Given the following brewery exists:
      | id | user                  | name  |
      | 1  | private_token: x1y2z3 | Abita |
    When I update the "Abita" brewery via the API using the "x1y2z3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 200 response
    And the following brewery should exist:
      | user                  | name          |
      | private_token: x1y2z3 | Southern Tier |

  Scenario: Updating a brewery with a public token
    Given the following brewery exists:
      | id | user                 | name  |
      | 1  | public_token: a1b2c3 | Abita |
    When I update the "Abita" brewery via the API using the "a1b2c3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 401 response
    And the following brewery should exist:
      | user                 | name  |
      | public_token: a1b2c3 | Abita |

  Scenario: Updating a brewery not owned by the requesting API client as an administrator
     Given the following brewery exists:
      | id | user                  | name  |
      | 1  | private_token: x1y2z3 | Abita |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Abita" brewery via the API using the "e1f2g3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 200 response
    And the following brewery should exist:
      | user                  | name          |
      | private_token: x1y2z3 | Southern Tier |

  Scenario: Updating a brewery not owned by the requesting API client
    Given the following brewery exists:
      | id | user                  | name  |
      | 1  | private_token: d4e5f6 | Abita |
    When I update the "Abita" brewery via the API using the "a1b2c3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 401 response
    And the following brewery should exist:
      | user                  | name  |
      | private_token: d4e5f6 | Abita |

  Scenario: Updating a brewery not owned by an API client
    Given the following brewery exists:
      | id | user | name  |
      | 1  |      | Abita |
    When I update the "Abita" brewery via the API using the "a1b2c3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 401 response
    And the following brewery should exist:
      | id | name  |
      | 1  | Abita |

  Scenario: Updating a brewery not owned by an API client as an administrator
    Given the following brewery exists:
      | id | user | name  |
      | 1  |      | Abita |
    And the following user exists:
      | private_token | administrator |
      | e1f2g3        | true          |
    When I update the "Abita" brewery via the API using the "e1f2g3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 200 response
    And the following brewery should exist:
      | id | name          |
      | 1  | Southern Tier |

  Scenario: Updating a brewery with validation errors
    Given the following brewery exists:
      | id | user                  | name  |
      | 1  | private_token: x1y2z3 | Abita |
    When I update the "Abita" brewery via the API using the "x1y2z3" token:
      | name | url |
      |      | WTF |
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "name" : ["can't be blank"],
            "url"  : ["is invalid"]
          }
        }
      """

  Scenario: Updating a brewery that does not exist
    When I send an API PUT request to /v1/breweries/1.json?token=x1y2z3
    Then I should receive a 404 response

  Scenario: Updating a brewery without an API token
    When I send an API PUT request to /v1/breweries/1.json
    Then I should receive a 401 response
