class OrdersController < ApplicationController
  def new
    @product = Product.find(params[:id])
    @order = Order.new(quantity: 1)
  end

  def create
    @product = Product.find(params[:id])
    @order = Order.new(order_params)
    @order.product = @product
    @order.user_id = session[:user_id].to_i
    @order.price = @order.product.price * @order.quantity
    user_wallet = Wallet.find_by(user_id: session[:user_id].to_i)
 
    if user_wallet.balance < @order.price
      flash[:alert_orders] = "Insufficient balance. Please top up your wallet."
      render :new
    else
      if @order.save
        user_wallet.balance -= @order.price
        transaction = Transaction.create(
          source_wallet_id: user_wallet.id,
          orders_id: @order.id,
          product_id: @order.product_id,
          amount: @order.price,
          transaction_type: "purchase",
          notes: @order.notes
        )
        transaction.save
        flash[:notice_orders] = "Order created successfully."
        redirect_to "/products", notice: "Order created successfully.", status: :created, content_type: "text/html"
      else
        flash[:alert_orders] = "Order creation failed."
        render :new
      end
    end    
  end

  private
  def order_params
    params.require(:order).permit(:product_id, :user_id, :quantity, :total_price, :notes)
  end
end
