Given /^I am signed in as "([^"]+)"$/ do |name|
  steps %{
    Given I am on the homepage
    And I follow "Sign up for an API token."
    And I fill in "Name" with "#{name}"
    And I fill in "E-mail" with "#{name.underscore}@example.com"
    And I fill in "Password" with "test"
    And I fill in "Password Confirmation" with "test"
    And I press "Sign Up"
  }
end
