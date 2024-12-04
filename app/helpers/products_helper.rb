module ProductsHelper
  def fetch_and_save_products
    url = URI.parse("https://fakestoreapi.com/products")
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      products = JSON.parse(response.body)

      products.each do |product_data|
        Product.create!(
          title: product_data["title"],
          price: product_data["price"],
          description: product_data["description"],
          category: product_data["category"],
          image: product_data["image"],
          rating_rate: product_data["rating"]["rate"],
          rating_count: product_data["rating"]["count"]
        )
      end
    else
      flash[:alert] = "Failed to fetch products from the API."
    end
  end
end
