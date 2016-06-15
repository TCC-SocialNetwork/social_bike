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
    
    route = current_user.create_route(params[:title], params[:distance], points, params[:travel_mode])
    
    if route 
      redirect_to route_url(route)
    else
      render :new
    end
  end

  def show
    @origin = @route.locations.first
    @destination = @route.locations.last
    @mode_of_travel = @route.mode_of_travel
    puts "**********************************"
    puts @mode_of_travel
    puts "**********************************"
    @locations = []
  end

  private

  def set_route
    @route = SocialFramework::Route.find params[:id]
  end
end
