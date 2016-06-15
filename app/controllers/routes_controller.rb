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
    @locations = []
  end

  def compare_routes
    @routes = current_user.routes
    @friends = current_user.relationships
    @friend_routes = []
  end

  def check_routes
    principal_route = SocialFramework::Route.find(params[:my_route])
    secondary_route = SocialFramework::Route.find(params[:my_friend_route])

    @origin = principal_route.locations.first
    @destination = principal_route.locations.last
    @mode_of_travel = principal_route.mode_of_travel
    
    route_contex = SocialFramework::RouteHelper::RouteContext.new
    @compatibility = route_contex.compare_routes(principal_route, secondary_route)

    @locations = []
    if(@compatibility[:principal_route][:deviation] == :both or @compatibility[:principal_route][:deviation] == :origin)
      @locations << {location: "#{secondary_route.locations.first.latitude}, #{secondary_route.locations.first.longitude}"}
    end

    if(@compatibility[:principal_route][:deviation] == :both or @compatibility[:principal_route][:deviation] == :destiny)
      @locations << {location: "#{secondary_route.locations.last.latitude}, #{secondary_route.locations.last.longitude}"}
    end
  end

  def friend_routes
    @friend_routes = SocialFramework::User.find(params[:id]).routes
    render partial: "friend_routes", object: @friend_routes
  end

  private

  def set_route
    @route = SocialFramework::Route.find params[:id]
  end
end
