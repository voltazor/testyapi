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
        # redirect_to @user
        render json: UserSerializer.new(@user,  true)
      else
        render json: ErrorSerializer.new('failed'), status: 500
      end
    rescue ActiveRecord::RecordNotUnique
      render json: ErrorSerializer.new('user_already_exist'), status: 422
    end
  end

  def show
    user = get_user(params[:id])
    header = request.headers['Authorization'].to_s
    if user.nil?
      render json: ErrorSerializer.new('User not found'), status: 404
    else
      render json: UserSerializer.new(get_user(params[:id]),  header.eql?(user.token))
    end
  end

  def update
    header = request.headers['Authorization'].to_s
    user = get_user(params[:id])
    if user.nil?
      render json: ErrorSerializer.new('User not found'), status: 404
    else
      if header.eql?(user.token)
        unless params[:name].nil?
          user.name = params[:name]
        end
        unless params[:email].nil?
          user.email = params[:email]
        end
        unless params[:password].nil?
          user.password = params[:password]
        end
        user.save
        render plain: 'Success', status: 200
      else
        render json: ErrorSerializer.new('Unauthorized'), status: 401
      end
    end
  end

  def destroy
    header = request.headers['Authorization'].to_s
    user = get_user(params[:id])
    if user.nil?
      render json: ErrorSerializer.new('User not found'), status: 404
    else
      if header.eql?(user.token)
        User.delete(params[:id])
        render plain: 'Success', status: 200
      else
        render json: ErrorSerializer.new('Unauthorized'), status: 401
      end
    end
  end

  def check_token(user_id, token)
    get_user(user_id).token.eql?(token)
  end

  def get_user(user_id)
    User.where(id: user_id).first
  end

  def format_users(users)
    formatted_users = []
    users.each do |user|
      formatted_users << UserSerializer.new(user, false)
    end
    formatted_users
  end

  class UserSerializer

    def initialize(user, show_token)
      @id = user.id
      @email = user.email
      @name = user.name
      if show_token
        @password = user.password
        @token = user.token
      end
    end

  end

  class ErrorSerializer

    def initialize(error)
      @error = error
    end

  end

end
