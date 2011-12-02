class Api::V1::BeerPresenter < ApiPresenter
  attr_reader :beer

  def initialize(beer)
    @beer = beer
  end

  def as_json
    { id:          beer.id,
      name:        beer.name,
      description: beer.description,
      abv:         beer.abv,
      created_at:  beer.created_at,
      updated_at:  beer.updated_at,
      brewery:     {
        id:   beer.brewery.id,
        name: beer.brewery.name
      }
    }
  end
end
