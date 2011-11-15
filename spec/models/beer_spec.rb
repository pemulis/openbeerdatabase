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
end

describe Beer, ".search" do
  let(:user)  { Factory(:user) }
  let(:order) { "id asc" }
  let(:scope) { stub }

  before do
    Beer.stubs(scoped: scope, clean_order: order)
    User.stubs(find_by_public_or_private_token: user)
    scope.stubs page:     scope,
                where:    scope,
                order:    scope,
                includes: scope,
                per_page: scope
  end

  it "includes the brewery assocation" do
    Beer.search
    scope.should have_received(:includes).with(:brewery)
  end

  it "includes public records, when no token is present" do
    Beer.search
    User.should have_received(:find_by_public_or_private_token).never
    scope.should have_received(:where).with(user_id: [nil])
  end

  it "includes public and private records, when token is present" do
    Beer.search(token: "token")
    User.should have_received(:find_by_public_or_private_token).with("token")
    scope.should have_received(:where).with(user_id: [nil, user.id])
  end

  it "limits the query to a specific page" do
    Beer.search
    scope.should have_received(:page).with(1)
    Beer.search(page: 2)
    scope.should have_received(:page).with(2)
  end

  it "limits the number of records per page" do
    Beer.search
    scope.should have_received(:per_page).with(50)
    Beer.search(per_page: 1)
    scope.should have_received(:per_page).with(1)
  end

  it "orders the results" do
    Beer.search(order: "order")
    Beer.should have_received(:clean_order).with("order", columns: Beer::SORTABLE_COLUMNS)
    scope.should have_received(:order).with(order)
  end

  it "filters results by name, when a query is provided" do
    Beer.search query: "  name  "
    scope.should have_received(:where).twice
    scope.should have_received(:where).with("name ILIKE ?", "%name%")
  end

  it "does not filter results by name, when no query is provided" do
    Beer.search
    scope.should have_received(:where).once
    scope.should have_received(:where).with("name ILIKE ?", "%%").never
  end

  it "returns the scope" do
    Beer.search({}).should == scope
  end
end
