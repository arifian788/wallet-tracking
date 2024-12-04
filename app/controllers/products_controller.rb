require "net/http"
require "json"
require "uri"

class ProductsController < ApplicationController
  def index
    @products = Product.all

    if @products.empty?
      helpers.fetch_and_save_products
      @products = Product.all
      flash[:notice] = "Products fetched and saved successfully."
    else
      flash[:notice] = "Products loaded from the database."
    end
  end
end
