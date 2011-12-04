require "spec_helper"

class ExampleSearchableModel
  SORTABLE_COLUMNS = %w(id name).freeze

  include SearchableModel
end

describe SearchableModel, ".clean_order" do
  let(:columns) { %w(id name) }

  subject { ExampleSearchableModel }

  it "defaults to id ASC" do
    subject.clean_order("").should == "id asc"
    subject.clean_order(" ").should == "id asc"
    subject.clean_order(nil).should == "id asc"
  end

  it "removes extraneous whitespace" do
    subject.clean_order("  id   desc  ").should == "id desc"
  end

  it "allows custom column and direction" do
    subject.clean_order("name DESC").should == "name desc"
  end

  it "allows ordering by specified columns" do
    subject.clean_order("id").should == "id asc"
    subject.clean_order("name").should == "name asc"
  end

  it "does not allow ordering by unspecified columns" do
    subject.clean_order("secret").should == "id asc"
    subject.clean_order("password").should == "id asc"
  end

  %w(asc desc).each do |direction|
    it "allows ordering in #{direction.upcase} direction" do
      subject.clean_order("id #{direction}").should == "id #{direction}"
    end
  end

  %w(up down left right).each do |direction|
    it "does not allow ordering in #{direction.upcase} direction" do
      subject.clean_order("id #{direction}").should == "id asc"
    end
  end
end
