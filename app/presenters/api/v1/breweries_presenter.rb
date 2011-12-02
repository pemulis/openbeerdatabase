class Api::V1::BreweriesPresenter < ApiPresenter
  attr_reader :breweries

  def initialize(breweries)
    @breweries = breweries
  end

  def as_json
    { page:      breweries.current_page,
      pages:     breweries.total_pages,
      total:     breweries.total_entries,
      breweries: breweries.collect { |brewery| Api::V1::BreweryPresenter.new(brewery) }
    }
  end
end
