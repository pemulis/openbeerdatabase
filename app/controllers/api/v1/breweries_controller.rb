class Api::V1::BreweriesController < Api::V1::BaseController
  def index
    breweries = Brewery.search(params)

    render json: Api::V1::BreweriesPresenter.new(breweries)
  end

  def show
    brewery = Brewery.find(params[:id])

    if params[:token].present?
      return head(:unauthorized) unless authorized_for?(brewery)
    end

    render json: Api::V1::BreweryPresenter.new(brewery)
  end

  def create
    brewery = current_user.breweries.build(params[:brewery])

    if brewery.save
      head :created, location: v1_brewery_url(brewery, format: :json)
    else
      render json:   { errors: brewery.errors },
             status: :bad_request
    end
  end

  def update
    brewery = Brewery.find(params[:id])

    if authorized_for?(brewery)
      if brewery.update_attributes(params[:brewery])
        head :ok
      else
        render json:   { errors: brewery.errors },
               status: :bad_request
      end
    else
      head :unauthorized
    end
  end

  def destroy
    brewery = Brewery.find(params[:id])

    if authorized_for?(brewery)
      if brewery.destroy
        head :ok
      else
        head :bad_request
      end
    else
      head :unauthorized
    end
  end
end
