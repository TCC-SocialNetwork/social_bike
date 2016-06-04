class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = current_user.schedule.events
  end

  # GET /foos/new
  def new
    @event = SocialFramework::Event.new
  end

  def create
    start = DateTime.parse(params[:start])
    duration = params[:duration].to_i.minutes
    particular = (params[:particular] == "1")
    
    current_user.schedule.create_event(params[:title], start, duration, params[:description], particular)
    
    redirect_to events_url
  end

end
