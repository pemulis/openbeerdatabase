class User < ActiveRecord::Base
  has_many :beers
  has_many :breweries

  has_secure_password

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format:     { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password,              presence: true, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :public_token,          presence: true
  validates :private_token,         presence: true

  attr_protected :public_token, :private_token, :administrator

  before_save       :clean_attributes
  before_validation :generate_tokens, on: :create

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end

  def self.find_by_public_or_private_token(token)
    where("public_token = :token OR private_token = :token", token: token).first
  end

  def can_access?(record)
    record.respond_to?(:user) && (administrator? || record.user == self)
  end

  protected

  def clean_attributes
    email.downcase!
  end

  def generate_tokens
    self.public_token  ||= Digest::SHA256.hexdigest([Time.now.to_f, rand].join)
    self.private_token ||= Digest::SHA256.hexdigest([Time.now.to_f, rand].join)
  end

  def password_required?
    password_digest.blank? || password.present?
  end
end
