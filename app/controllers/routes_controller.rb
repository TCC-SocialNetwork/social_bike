class RoutesController < ApplicationController
  before_action :set_route, only: [:show]

  def new
  end

  def create
    points = JSON(params[:points])
    points.each do |point|
      point.symbolize_keys!
      point[:latitude] = point[:latitude].to_f
      point[:longitude] = point[:longitude].to_f
    end

    if current_user.create_route(params[:title], params[:distance], points, params[:travel_mode])
      redirect_to root_url
    else
      render :new
    end
  end

  def show
  end

  private

  def set_route
    @route = SocialFramework::Route.find params[:id]
  end
end
