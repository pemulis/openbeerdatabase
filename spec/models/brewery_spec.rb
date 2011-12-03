require "spec_helper"

describe Brewery do
  it { should have_many(:beers) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should ensure_length_of(:url).is_at_most(255) }
  it { should allow_mass_assignment_of(:url) }
end

describe Brewery, ".search" do
  let(:user)  { Factory(:user) }
  let(:order) { "id asc" }
  let(:scope) { stub }

  before do
    Brewery.stubs(scoped: scope, clean_order: order)
    User.stubs(find_by_public_or_private_token: user)
    scope.stubs page:     scope,
                where:    scope,
                order:    scope,
                per_page: scope
  end

  it "includes public records, when no token is present" do
    Brewery.search
    User.should have_received(:find_by_public_or_private_token).never
    scope.should have_received(:where).with(user_id: [nil])
  end

  it "includes public and private records, when token is present" do
    Brewery.search(token: "token")
    User.should have_received(:find_by_public_or_private_token).with("token")
    scope.should have_received(:where).with(user_id: [nil, user.id])
  end

  it "limits the query to a specific page" do
    Brewery.search
    scope.should have_received(:page).with(1)
    Brewery.search(page: 2)
    scope.should have_received(:page).with(2)
  end

  it "limits the number of records per page" do
    Brewery.search
    scope.should have_received(:per_page).with(50)
    Brewery.search(per_page: 1)
    scope.should have_received(:per_page).with(1)
  end

  it "orders the results" do
    Brewery.search order: "order"
    Brewery.should have_received(:clean_order).with("order", columns: Brewery::SORTABLE_COLUMNS)
    scope.should have_received(:order).with(order)
  end

  it "returns the scope" do
    Brewery.search({}).should == scope
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
