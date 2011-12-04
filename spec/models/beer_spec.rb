require "spec_helper"

describe Beer do
  it { should belong_to(:brewery) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:brewery_id) }
  it { should_not allow_mass_assignment_of(:brewery_id) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(255) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(4096) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:abv) }
  it { should validate_numericality_of(:abv) }
  it { should allow_mass_assignment_of(:abv) }

  it "includes SearchableModel" do
    Beer.included_modules.should include(SearchableModel)
  end
end

describe Beer, ".filter_by_name" do
  let(:ale)    { Factory(:beer, :name => "Ale") }
  let(:ipa)    { Factory(:beer, :name => "IPA") }
  let!(:beers) { [ale, ipa] }

  it "filters resutls" do
    Beer.filter_by_name("Ale").should == [ale]
  end

  it "filters results, ignoring case" do
    Beer.filter_by_name("iPa").should == [ipa]
  end

  it "filters results, with wildcard matches" do
    Beer.filter_by_name("a").should == beers
  end

  it "does not filter results if no name is provided" do
    Beer.filter_by_name("").should  == beers
    Beer.filter_by_name(" ").should == beers
    Beer.filter_by_name(nil).should == beers
  end
end

describe Beer, ".for_token" do
  let!(:user) { Factory(:user) }
  let!(:ale)  { Factory(:beer, :user => nil) }
  let!(:ipa)  { Factory(:beer, :user => user) }

  before do
    User.stubs(:find_by_public_or_private_token)
  end

  it "includes public and private beers, provided a valid token" do
    User.stubs(:find_by_public_or_private_token => user)
    Beer.for_token("valid").should == [ale, ipa]
    User.should have_received(:find_by_public_or_private_token).with("valid")
  end

  it "includes public beers, provided an invalid token" do
    Beer.for_token("invalid").should == [ale]
    User.should have_received(:find_by_public_or_private_token).with("invalid")
  end

  it "includes public beers, provided no token" do
    Beer.for_token(nil).should == [ale]
    User.should have_received(:find_by_public_or_private_token).never
  end
end

describe Beer, ".search" do
  let(:scope) { stub }

  before do
    Beer.stubs(includes: scope)
    scope.stubs page:           scope,
                order_by:       scope,
                per_page:       scope,
                for_token:      scope,
                filter_by_name: scope
  end

  it "includes the brewery assocation" do
    Beer.search
    Beer.should have_received(:includes).with(:brewery)
  end

  it "includes records for the token" do
    Beer.search(token: "token")
    scope.should have_received(:for_token).with("token")
  end

  it "filters by name using the query" do
    Beer.search(query: "query")
    scope.should have_received(:filter_by_name).with("query")
  end

  it "limits the query to a specific page" do
    Beer.search
    scope.should have_received(:page).with(nil)
    Beer.search(page: 2)
    scope.should have_received(:page).with(2)
  end

  it "limits the number of records per page" do
    Beer.search
    scope.should have_received(:per_page).with(50)
    Beer.search(per_page: 1)
    scope.should have_received(:per_page).with(1)
  end

  it "sorts the results" do
    Beer.search(order: "order")
    scope.should have_received(:order_by).with("order")
  end

  it "returns the scope" do
    Beer.search({}).should == scope
  end
end

describe Beer, ".order_by" do
  let(:ale)        { Factory(:beer, :name => "Ale") }
  let(:ipa)        { Factory(:beer, :name => "IPA") }
  let!(:name_asc)  { [ale, ipa] }
  let!(:name_desc) { [ipa, ale] }

  it "orders beers" do
    Beer.order_by("name asc").should == name_asc
    Beer.order_by("name desc").should == name_desc
  end

  it "cleans the order string" do
    Beer.stubs(:clean_order => "id ASC")
    Beer.order_by("fake desc").should == name_asc
    Beer.should have_received(:clean_order).with("fake desc", columns: Beer::SORTABLE_COLUMNS)
  end
end
