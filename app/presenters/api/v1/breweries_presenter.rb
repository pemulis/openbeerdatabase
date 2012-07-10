class Api::V1::BreweriesPresenter < Api::V1::CollectionPresenter
  def klass
    Api::V1::BreweryPresenter
  end

  def type
    :breweries
  end
end
