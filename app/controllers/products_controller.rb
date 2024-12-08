require "net/http"
require "json"
require "uri"

class ProductsController < ApplicationController
  def index
    if session[:user_id]
      @products = Product.all

      if @products.empty?
        helpers.fetch_and_save_products
        @products = Product.all
        flash[:notice_products] = "Products fetched and saved successfully."
      else
        flash[:notice_products] = "Products loaded from the database."
      end
    else
      redirect_to login_path
    end
  end

  def show
    @product = Product.find(params[:id])
  end
end
