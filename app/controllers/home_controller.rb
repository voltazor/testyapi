class HomeController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @routes = []
    routes = Sextant.format_routes
    routes.each do |r|
      if r[:path].include?('api') or r[:path].include?('user')
        i = r[:path].index('(.:format)')
        r[:path] = r[:path][0, i]
        @routes << r
      end
    end
  end

  def get
    render json: MethodSerializer.new('get')
  end

  def post
    render json: MethodSerializer.new('post')
  end

  def put
    render json: MethodSerializer.new('put')
  end

  def delete
    render json: MethodSerializer.new('delete')
  end

  class MethodSerializer

    def initialize(method)
      @method = method
    end

  end

end
