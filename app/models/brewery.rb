class Brewery < ActiveRecord::Base
  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  include SearchableModel

  has_many   :beers
  belongs_to :user

  validates :name, presence: true, length: { maximum: 255 }
  validates :url,  length: { maximum: 255 },
                   format: {
                     with:      %r{\Ahttps?://((([\w_]+\.)*)?[\w_]+([-.][\w_]+)*\.[a-z]{2,6}\.?)([/?]\S*)?\Z}i,
                     allow_nil: true
                   }

  attr_accessible :name, :url

  before_destroy :ensure_no_associated_beers_exist

  def self.search(options = {})
    user  = User.find_by_public_or_private_token(options[:token]) if options[:token].present?
    order = clean_order(options[:order], columns: SORTABLE_COLUMNS)

    scoped
      .where(user_id: [nil, user.try(:id)].uniq)
      .page(options[:page] || 1)
      .per_page(options[:per_page] || 50)
      .order(order)
  end

  private

  def ensure_no_associated_beers_exist
    beers.count == 0
  end
end
