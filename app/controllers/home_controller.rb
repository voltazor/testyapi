class HomeController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @routes = []
    routes = Sextant.format_routes
    routes.each do |r|
      if r[:path].include?('api')
        i = r[:path].index('(.:format)')
        r[:path] = r[:path][0, i]
        @routes << r
      end
    end
  end

  def get
    render json: 'get'
  end

  def post
    render json: 'post'
  end

  def put
    render json: 'put'
  end

  def delete
    render json: 'delete'
  end

end
