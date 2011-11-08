require "spec_helper"

describe User do
  subject { Factory(:user) }

  it { should have_many(:beers) }
  it { should have_many(:breweries) }

  it { should validate_presence_of(:public_token) }
  it { should_not allow_mass_assignment_of(:public_token) }

  it { should validate_presence_of(:private_token) }
  it { should_not allow_mass_assignment_of(:private_token) }

  it { should_not allow_mass_assignment_of(:administrator) }
end

describe User, "being created" do
  it "requires a name" do
    Factory.build(:user, name: nil).should_not be_valid
  end

  it "requires an e-mail" do
    Factory.build(:user, email: nil).should_not be_valid
  end

  it "requires a valid e-mail" do
    Factory.build(:user, email: "@.com").should_not be_valid
  end

  it "requires a unique e-mail" do
    user = Factory(:user)

    Factory.build(:user, email: user.email.upcase).should_not be_valid
  end

  it "requires a password" do
    Factory.build(:user, password: nil).should_not be_valid
  end

  it "requires a password confirmation" do
    Factory.build(:user, password_confirmation: nil).should_not be_valid
  end

  it "requires password to match confirmation" do
    Factory.build(:user, password: "nope").should_not be_valid
  end

  it "downcases e-mail" do
    Factory(:user, email: "SoMe@GuY.com").email.should == "some@guy.com"
  end

  it "generates a public API token" do
    user = Factory.build(:user)
    user.public_token.should be_nil
    user.save
    user.public_token.should_not be_nil
  end

  it "generates a private API token" do
    user = Factory.build(:user)
    user.private_token.should be_nil
    user.save
    user.private_token.should_not be_nil
  end
end

describe User, "being updated" do
  subject { Factory(:user) }

  let!(:public_token) { subject.public_token.to_s }
  let!(:private_token) { subject.private_token.to_s }

  it "does not regenerate public API token" do
    subject.updated_at = Time.now
    subject.save
    subject.public_token.to_s.should == public_token
  end

  it "does not regenerate private API token" do
    subject.updated_at = Time.now
    subject.save
    subject.private_token.to_s.should == private_token
  end
end

describe User, ".authenticate" do
  let(:user)     { Factory(:user) }
  let(:email)    { user.email }
  let(:password) { "test" }

  it "returns a user when credentials are correct" do
    User.authenticate(email, password).should == user
  end

  it "returns nil when e-mail is incorrect" do
    User.authenticate("what@example.com", password).should be_nil
  end

  it "returns nil when password is incorrect" do
    User.authenticate(email, "wrong").should be_false
  end
end

describe User, ".find_by_public_or_private_token" do
  let(:user) { Factory(:user) }

  it "finds a user by public token" do
    User.find_by_public_or_private_token(user.public_token).should == user
  end

  it "finds a user by private token" do
    User.find_by_public_or_private_token(user.private_token).should == user
  end
end

describe User, "#can_access?" do
  subject { Factory(:user) }

  let(:user_beer)  { Factory(:beer, user: subject) }
  let(:other_beer) { Factory(:beer) }

  it "returns true when the record is owned by the user" do
    subject.can_access?(user_beer).should == true
  end

  it "returns true when the record is not owned by the user but the user is an administrator" do
    subject.administrator = true
    subject.can_access?(other_beer).should == true
  end

  it "returns false when the record is not owned by the user" do
    subject.can_access?(other_beer).should == false
  end

  it "returns false when record does not respond to user" do
    subject.can_access?({}).should == false
  end
end
