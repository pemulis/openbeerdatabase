class Beer < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  include SearchableModel

  belongs_to :brewery
  belongs_to :user

  validates :brewery_id,  presence: true
  validates :name,        presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 4096 }
  validates :abv,         presence: true, numericality: true

  attr_accessible :name, :description, :abv

  def self.search(options = {})
    user  = User.find_by_public_or_private_token(options[:token]) if options[:token].present?
    order = clean_order(options[:order], columns: SORTABLE_COLUMNS)

    scoped
      .includes(:brewery)
      .where(user_id: [nil, user.try(:id)].uniq)
      .page(options[:page] || 1)
      .per_page(options[:per_page] || 50)
      .order(order)
  end
end
