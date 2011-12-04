module SearchableModel
  extend ActiveSupport::Concern

  included do
    def self.clean_order(order, options = {})
      column, direction = order.to_s.split(" ", 2).map(&:to_s).map(&:downcase).map(&:strip)

      column    = "id"  unless options[:columns].include?(column)
      direction = "asc" unless %w(asc desc).include?(direction)

      "#{column} #{direction}"
    end

    def self.filter_by_name(name)
      if name.present?
        where("name ILIKE ?", "%#{name}%")
      else
        where("")
      end
    end

    def self.for_token(token)
      user = User.find_by_public_or_private_token(token) if token.present?

      if user.present?
        where(user_id: [nil, user.id])
      else
        where(user_id: nil)
      end
    end

    def self.order_by(string)
      clean_string = clean_order(string, columns: self::SORTABLE_COLUMNS)

      order(clean_string)
    end
  end
end
