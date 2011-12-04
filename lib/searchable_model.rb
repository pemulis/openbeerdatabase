module SearchableModel
  extend ActiveSupport::Concern

  included do
    def self.clean_order(order)
      order   = order.to_s.downcase.strip
      columns = self::SORTABLE_COLUMNS.join("|")

      _, column, direction = order.match(/^(#{columns})*\s*(asc|desc)*$/i).to_a

      column    = "id"  if column.blank?
      direction = "asc" if direction.blank?

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
      order(clean_order(string))
    end
  end
end
