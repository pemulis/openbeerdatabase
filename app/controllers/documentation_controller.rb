class DocumentationController < ApplicationController
  def show
    render :action => params[:id]
  end
end
