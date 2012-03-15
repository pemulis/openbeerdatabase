class Api::V1::BeersPresenter < ApiPresenter
  def initialize(beers)
    @beers = beers
  end

  def as_json
    { page:  @beers.current_page,
      pages: @beers.total_pages,
      total: @beers.total_entries,
      beers: @beers.collect { |beer| Api::V1::BeerPresenter.new(beer) }
    }
  end
end
