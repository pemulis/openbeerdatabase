class Api::V1::BreweryPresenter < ApiPresenter
  attr_reader :brewery

  def initialize(brewery)
    @brewery = brewery
  end

  def as_json
    { id:         brewery.id,
      name:       brewery.name,
      url:        brewery.url,
      created_at: brewery.created_at,
      updated_at: brewery.updated_at
    }
  end
end
