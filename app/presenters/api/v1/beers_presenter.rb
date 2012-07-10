class Api::V1::BeersPresenter < Api::V1::CollectionPresenter
  def klass
    Api::V1::BeerPresenter
  end

  def type
    :beers
  end
end
