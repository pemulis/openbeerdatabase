When /^I sign up as "([^"]*)"$/ do |name|
  visit        root_path
  click_link   "Sign up for an API token."
  fill_in      "user_name", with: name
  fill_in      "user_email", with: "#{name.underscore}@example.com"
  fill_in      "user_password", with: "test"
  fill_in      "user_password_confirmation", with: "test"
  click_button "Sign Up"
end

When /^I sign up with invalid information$/ do
  visit        root_path
  click_link   "Sign up for an API token."
  click_button "Sign Up"
end

When /^I go to the account page for "([^"]+)"$/ do |name|
  user = User.find_by_name!(name)

  visit user_path(user)
end

Then /^the API user with the (public|private) token "([^"]*)" should have (\d+) beers?$/ do |type, token, count|
  type = "#{type}_token"
  user = User.where(type => token).first
  user.beers.count.should == count
end

Then /^the API user with the (public|private) token "([^"]*)" should have (\d+) (?:brewery|breweries)?$/ do |type, token, count|
  type = "#{type}_token"
  user = User.where(type => token).first
  user.breweries.count.should == count
end

Then /^I should see the API tokens for the "([^"]*)" account$/ do |name|
  user = User.find_by_name!(name)

  should have_content(user.public_token)
  should have_content(user.private_token)
end

Then /^I should not see the API tokens for the "([^"]*)" account$/ do |name|
  user = User.find_by_name!(name)

  should_not have_content(user.public_token)
  should_not have_content(user.private_token)
end

Then /^I should be told to enter valid information$/ do
  should have_content("can't be blank")
end
