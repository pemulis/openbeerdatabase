class Api::V1::CollectionPresenter < ApiPresenter
  def initialize(items)
    @items = items
  end

  def as_json
    { :page  => @items.current_page,
      :pages => @items.total_pages,
      :total => @items.total_entries,
      type   => @items.collect { |item| klass.new(item) }
    }
  end
end
