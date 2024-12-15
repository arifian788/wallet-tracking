class HomeController < ApplicationController
  def index
    if session[:user_id]
      redirect_to home_path
    else
      @products = Product.all
    end
  end
end
