class OrdersController < ApplicationController
  def new
    @product = Product.find(params[:id])
    @order = Order.new(quantity: params[:quantity] || 1)
  end

  def create
    @product = Product.find(params[:id])
    @order = Order.new(order_params)
    @order.user_id = session[:user_id]
    @order.product_id = @product.id
    @order.total_price = @product.price * @order.quantity


    if @order
      @order.user_id = session[:user_id]
      @order.product_id = @product.id
      @order.total_price = @product.price * @order.quantity
      wallet = Wallet.find_by(user_id: session[:user_id], wallet_number: params[:order][:wallet_number])
      puts "wallet balance: #{wallet.balance}"
      puts "order total price: #{@order.total_price}"
      if wallet.balance < @order.total_price
        flash[:alert_orders] = "Insufficient balance"
        render :new, status: :unprocessable_entity, notice: flash[:alert_orders]
      else
        wallet.update(balance: wallet.balance - @order.total_price)

        Order.create(
          user_id: @order.user_id,
          product_id: @order.product_id,
          quantity: @order.quantity,
          price: @product.price,
          total_price: @order.total_price,
          notes: @order.notes
        )

        order_id = Order.last.id
        transaction = Transaction.create(
          source_wallet_id:  @order.user_id,
          orders_id: order_id,
          product_id: @order.product_id,
          user_id: @order.user_id,
          amount: @order.total_price,
          transaction_type: "purchase",
          notes: @order.notes
        )

        if transaction.save
          flash[:notice_transaction] = "Product purchase successful!"
          redirect_to transactions_path and return
        else
          flash[:alert_transaction] = transaction.errors.full_messages.join(", ")
          render :new
        end
      end
    end
  end


  private
  def order_params
    params.require(:order).permit(:product_id, :quantity, :total_price, :notes)
  end
end
