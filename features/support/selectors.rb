module HtmlSelectorsHelpers
  def selector_for(locator)
    case locator
    when /^the API token request form$/
      "form[method='post'][action='http://openbeerdatabase.createsend.com/t/r/s/ndyukh/']"

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
