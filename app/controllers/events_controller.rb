class EventsController < ApplicationController
  before_action :set_event, only: [:enter, :show, :invite, :remove_participant, :accept_invitation]
  before_action :set_user, only: [:invite, :remove_participant]
  before_action :authenticate_user!

  def show
    @friends = current_user.relationships("friend")
    @confirmed_users = @event.users
    @not_confirmed_users = @event.users(false)
    @is_in_event = (@confirmed_users.include? current_user)
    @is_invited = (@not_confirmed_users.include? current_user)

    @friends = @friends - @confirmed_users - @not_confirmed_users
  end

  # GET /foos/new
  def new
    @event = SocialFramework::Event.new
  end

  def create
    start = DateTime.parse(params[:start])
    duration = params[:duration].to_i.minutes
    particular = (params[:particular] == "1")
    
    event = current_user.schedule.create_event(params[:title], start, duration, params[:description], particular)
    
    if event
      redirect_to event_url(event)
    else
      render :create
    end
  end

  def enter
    if current_user.schedule.enter_in_event(@event)
      redirect_to event_url(@event), notice: "Você está participando deste evento!"
    else
      redirect_to event_url(@event), alert: "Você não pode participar deste evento!"
    end
  end

  def invite
    if @event.invite current_user, @user
      redirect_to event_url(@event), notice: "Usuário convidado com sucesso!"
    else
      redirect_to event_url(@event), alert: "Usuário não pôde ser convidado!"
    end
  end

  def remove_participant
    if @event.remove_participant current_user, @user
      redirect_to event_url(@event), notice: "Usuário removido com sucesso!"
    else
      redirect_to event_url(@event), alert: "Usuário não pôde ser removido!"
    end
  end

  def accept_invitation
    puts "............................"
    puts "............................"
    puts "............................"
    puts "............................"
    if current_user.schedule.confirm_event @event
      redirect_to event_url(@event), notice: "Você está participando deste evento!"
    else
      redirect_to event_url(@event), alert: "Você não pode participar deste evento!"
    end
  end

  private

  def set_event
    @event = SocialFramework::Event.find params[:id]
  end

  def set_user
    @user = SocialFramework::User.find params[:user_id]
  end
end
