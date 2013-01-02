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
    for_token(options[:token])
      .filter_by_name(options[:query])
      .page(options[:page])
      .per_page(options[:per_page] || 50)
      .order_by(options[:order])
  end

  def public?
    user_id.nil?
  end

  private

  def ensure_no_associated_beers_exist
    beers.count == 0
  end
end
