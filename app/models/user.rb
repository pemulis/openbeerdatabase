class User < ActiveRecord::Base
  has_many :beers
  has_many :breweries

  validates :public_token,  :presence => true
  validates :private_token, :presence => true

  attr_protected :public_token, :private_token

  before_validation :generate_tokens, :on => :create

  def self.find_by_token(token)
    where(["public_token = :token OR private_token = :token", :token => token]).first
  end

  protected

  def generate_tokens
    self.public_token  ||= Digest::SHA256.hexdigest("-#{id}--#{Time.now.to_f}--#{rand}-")
    self.private_token ||= Digest::SHA256.hexdigest("-#{id}--#{Time.now.to_f}--#{rand}-")
  end
end
