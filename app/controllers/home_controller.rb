class HomeController < ApplicationController

  def index

  end

  def index_json
    render json: 'hello'
  end

end
