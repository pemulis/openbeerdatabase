module SearchableModel
  extend ActiveSupport::Concern

  included do
    def self.clean_order(order, options = {})
      column, direction = order.to_s.split(" ", 2).map(&:to_s).map(&:downcase).map(&:strip)

      column    = "id"  unless options[:columns].include?(column)
      direction = "asc" unless %w(asc desc).include?(direction)

      "#{column} #{direction}"
    end
  end
end
