require "spec_helper"

describe SearchableModel, ".clean_order" do
  let(:columns) { %w(id name) }

  subject do
    Class.new do
      include SearchableModel
    end
  end

  it "defaults to id ASC" do
    subject.clean_order(nil, columns: columns).should == "id asc"
  end

  it "removes extraneous whitespace" do
    subject.clean_order("  id   desc  ", columns: columns).should == "id desc"
  end

  it "allows custom column and direction" do
    subject.clean_order("name DESC", columns: columns).should == "name desc"
  end

  it "allows ordering by specified columns" do
    subject.clean_order("id", columns: columns).should == "id asc"
    subject.clean_order("name", columns: columns).should == "name asc"
  end

  it "does not allow ordering by unspecified columns" do
    subject.clean_order("secret", columns: columns).should == "id asc"
    subject.clean_order("password", columns: columns).should == "id asc"
  end

  %w(asc desc).each do |direction|
    it "allows ordering in #{direction.upcase} direction" do
      subject.clean_order("id #{direction}", columns: columns).should == "id #{direction}"
    end
  end

  %w(up down left right).each do |direction|
    it "does not allow ordering in #{direction.upcase} direction" do
      subject.clean_order("id #{direction}", columns: columns).should == "id asc"
    end
  end
end
