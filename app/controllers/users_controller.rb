class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render json: format_users(User.all)
  end

  def create
    begin
      @user = User.new(email: params[:email], password: params[:password], name: params[:name])
      if @user.save
        @user.token = Digest::SHA2.hexdigest(@user.id.to_s + @user.email + @user.password)
        @user.save
        redirect_to @user
      else
        render json: ErrorSerializer.new('failed'), status: 500
      end
    rescue ActiveRecord::RecordNotUnique
      render json: ErrorSerializer.new('user_already_exist'), status: 422
    end
  end

  def show
    render json: UserSerializer.new(User.where(id: params[:id]).first)
  end

  def format_users(users)
    formatted_users = []
    users.each do |user|
      formatted_users << UserSerializer.new(user)
    end
    formatted_users
  end

  class UserSerializer

    def initialize(user)
      @id = user.id
      @email = user.email
      @name = user.name
      @token = user.token
    end

  end

  class ErrorSerializer

    def initialize(error)
      @error = error
    end

  end

end
