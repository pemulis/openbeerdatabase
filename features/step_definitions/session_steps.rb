When /^I sign in with "([^"]*)" and "([^"]*)"$/ do |email, password|
  visit        root_path
  click_link   "Sign in"
  fill_in      "E-mail",   with: email
  fill_in      "Password", with: password
  click_button "Sign In"
end

Then /^I should be signed in as "([^"]+)"$/ do |name|
  should have_content("Signed in as #{name}.")
end

Then /^I should be told my credentials are invalid$/ do
  should have_content("E-mail or password is incorrect. Please try again.")
end
