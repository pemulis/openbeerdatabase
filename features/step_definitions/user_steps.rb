Then /^the API user with the (public|private) token "([^"]*)" should have (\d+) beers?$/ do |type, token, count|
  User.__send__("find_by_#{type}_token", token).beers.count.should == count
end

Then /^the API user with the (public|private) token "([^"]*)" should have (\d+) (?:brewery|breweries)?$/ do |type, token, count|
  User.__send__("find_by_#{type}_token", token).breweries.count.should == count
end
