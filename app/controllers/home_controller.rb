class HomeController < ApplicationController
  before_action :set_user, only: [:add_friend, :accept_friend, :remove_friend]
  before_action :authenticate_user!

  def index
    @users ||= Array.new
    @events ||= Array.new
    @friends = current_user.relationships("friend")
    @requests_friendship = current_user.relationships("friend", false, "other")
    @requests_open = current_user.relationships("friend", false, "self")
  end

  def search
    @search = params[:search]
    map = { username: @search, email: @search }

    if params[:commit] == 'Continuar'
      hash = current_user.graph.search(map, true)
    else
      hash = current_user.graph.search(map)
    end

    @users = hash[:users]
    @events = hash[:events]

    render :index
  end

  def add_friend
    if current_user.create_relationship(@user, "friend")
      message = "adicionado"
    else
      message = "não adicionado"
    end

    redirect_to root_url, notice: message
  end

  def accept_friend
    if current_user.confirm_relationship(@user, "friend")
      mensagem = "confirmado"
    else
      mensagem = "não confirmado"
    end
    redirect_to root_url, notice: mensagem
  end

  def remove_friend
    if current_user.remove_relationship(@user, "friend")
      mensagem = "removido"
    else
      mensagem = "não removido"
    end
    redirect_to root_url, notice: mensagem
  end

  private
    def set_user
      @user = SocialFramework::User.find(params[:id])
    end
end
