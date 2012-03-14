require "spec_helper"

describe Brewery do
  it { should have_many(:beers) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should ensure_length_of(:url).is_at_most(255) }
  it { should allow_mass_assignment_of(:url) }

  it "includes SearchableModel" do
    Beer.included_modules.should include(SearchableModel)
  end
end

describe Brewery, ".filter_by_name" do
  let(:abita)      { Factory(:brewery, :name => "Abita") }
  let(:harpoon)    { Factory(:brewery, :name => "Harpoon") }
  let!(:breweries) { [abita, harpoon] }

  it "filters resutls" do
    Brewery.filter_by_name("Abita").should == [abita]
  end

  it "filters results, ignoring case" do
    Brewery.filter_by_name("harPOON").should == [harpoon]
  end

  it "filters results, with wildcard matches" do
    Brewery.filter_by_name("a").should == breweries
  end

  it "does not filter results if no name is provided" do
    Brewery.filter_by_name("").should  == breweries
    Brewery.filter_by_name(" ").should == breweries
    Brewery.filter_by_name(nil).should == breweries
  end
end

describe Brewery, ".for_token" do
  let!(:user)    { Factory(:user) }
  let!(:abita)   { Factory(:brewery, :user => nil) }
  let!(:harpoon) { Factory(:brewery, :user => user) }

  before do
    User.stubs(:find_by_public_or_private_token)
  end

  it "includes public and private breweries, provided a valid token" do
    User.stubs(:find_by_public_or_private_token => user)
    Brewery.for_token("valid").should == [abita, harpoon]
    User.should have_received(:find_by_public_or_private_token).with("valid")
  end

  it "includes public breweries, provided an invalid token" do
    Brewery.for_token("invalid").should == [abita]
    User.should have_received(:find_by_public_or_private_token).with("invalid")
  end

  it "includes public breweries, provided no token" do
    Brewery.for_token(nil).should == [abita]
    User.should have_received(:find_by_public_or_private_token).never
  end
end

describe Brewery, ".search" do
  let(:scope) { stub }

  before do
    Brewery.stubs(for_token: scope)
    scope.stubs(page:           scope,
                order_by:       scope,
                per_page:       scope,
                filter_by_name: scope)
  end

  it "includes records for the token" do
    Brewery.search(token: "token")
    Brewery.should have_received(:for_token).with("token")
  end

  it "filters by name using the query" do
    Brewery.search(query: "query")
    scope.should have_received(:filter_by_name).with("query")
  end

  it "limits the query to a specific page" do
    Brewery.search
    scope.should have_received(:page).with(nil)
    Brewery.search(page: 2)
    scope.should have_received(:page).with(2)
  end

  it "limits the number of records per page" do
    Brewery.search
    scope.should have_received(:per_page).with(50)
    Brewery.search(per_page: 1)
    scope.should have_received(:per_page).with(1)
  end

  it "sorts the results" do
    Brewery.search(order: "order")
    scope.should have_received(:order_by).with("order")
  end

  it "returns the scope" do
    Brewery.search({}).should == scope
  end
end

describe Brewery, ".order_by" do
  let(:abita)      { Factory(:brewery, :name => "Abita") }
  let(:harpoon)    { Factory(:brewery, :name => "Harpoon") }
  let!(:name_asc)  { [abita, harpoon] }
  let!(:name_desc) { [harpoon, abita] }

  it "orders breweries" do
    Brewery.order_by("name asc").should == name_asc
    Brewery.order_by("name desc").should == name_desc
  end

  it "cleans the order string" do
    Brewery.stubs(:clean_order => "id ASC")
    Brewery.order_by("fake desc").should == name_asc
    Brewery.should have_received(:clean_order).with("fake desc")
  end
end

describe Brewery, "url" do
  it "allows valid URLs" do
    [ nil,
      "http://example.com",
      "http://example.com/",
      "http://www.example.com/",
      "http://sub.domain.example.com/",
      "http://bbc.co.uk",
      "http://example.com?foo",
      "http://example.com?url=http://example.com",
      "http://www.sub.example.com/page.html?foo=bar&baz=%23#anchor",
      "http://example.com/~user",
      "http://example.xy",
      "http://example.museum",
      "HttP://example.com",
      "https://example.com",
      "http://example.com.",
      "http://example.com./foo"
    ].each do |url|
      Factory.build(:brewery, url: url).should be_valid
    end
  end

  it "disallows invalid URLs" do
   [ 1,
     "",
     " ",
     "url",
     "www.example.com",
     "http://ex ample.com",
     "http://example.com/foo bar",
     "http://256.0.0.1",
     "http://u:u:u@example.com",
     "http://r?ksmorgas.com",
     "http://example",
     "http://example.c",
     "http://example.toolongtld"
    ].each do |url|
      Factory.build(:brewery, url: url).should_not be_valid
    end
  end
end

describe Brewery, "being destroyed" do
  subject { Factory(:brewery) }

  it "is destroyed when it has zero beers" do
    subject.destroy.should be_true
  end

  it "is not destroyed when it has beers" do
    Factory(:beer, brewery: subject)
    subject.destroy.should be_false
  end
end
