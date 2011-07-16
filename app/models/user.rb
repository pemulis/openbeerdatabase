class User < ActiveRecord::Base
  has_many :beers
  has_many :breweries

  validates :name,  :presence   => true
  validates :email, :presence   => true,
                    :uniqueness => { :case_sensitive => false },
                    :format     => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, :presence => true, :confirmation => true, :if => :password_required?
  validates :password_confirmation, :presence => true, :if => :password_required?
  validates :public_token,  :presence => true
  validates :private_token, :presence => true

  attr_protected :public_token, :private_token, :administrator

  before_save       :clean_attributes, :hash_password
  before_validation :generate_tokens, :on => :create

  attr_writer :password

  def self.authenticate(email, password)
    user = where(:email => email).first
    user if user.present? && user.password == password
  end

  def self.find_by_public_or_private_token(token)
    where("public_token = :token OR private_token = :token", :token => token).first
  end

  def can_access?(record)
    record.respond_to?(:user) && (administrator? || record.user == self)
  end

  def password
    if hashed_password
      @password ||= BCrypt::Password.new(hashed_password)
    else
      @password
    end
  end

  protected

  def clean_attributes
    email.downcase!
  end

  def generate_tokens
    self.public_token  ||= Digest::SHA256.hexdigest([Time.now.to_f, rand].join)
    self.private_token ||= Digest::SHA256.hexdigest([Time.now.to_f, rand].join)
  end

  def hash_password
    if password_required?
      self.hashed_password = BCrypt::Password.create(password)
    end
  end

  def password_required?
    hashed_password.blank? || !password.blank?
  end
end
