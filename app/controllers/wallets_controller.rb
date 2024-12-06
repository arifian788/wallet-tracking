class WalletsController < ApplicationController
  def new
    @wallet = Wallet.new
    @user = User.find(session[:user_id])
    @wallet = Wallet.where(user_id: @user.id)
  end

  def create
    puts "abc"
    @wallet = Wallet.create(
      wallet_number: rand(10**9..10**10 - 1),
      balance: 0,
      user_id: session[:user_id]
    )

    render :new
  end

  def topup
    @user = User.find(session[:user_id])
    @wallet = Wallet.where(user_id: @user.id, wallet_number: params[:wallet][:wallet_number]).first

    if @wallet
      balance_wallet = @wallet.balance.to_i + params[:wallet][:amount].to_i
      @wallet.update(wallet_number: params[:wallet][:wallet_number], balance: balance_wallet)
      puts "wallet: #{@wallet.inspect}"

      transaction = Transaction.create(
        source_wallet_id: @wallet.id,
        amount: params[:wallet][:amount],
        transaction_type: "topup",
        notes: params[:wallet][:notes]
      )

      if transaction.save
        flash[:notice_transaction] = "Top-up successful! Your wallet number is #{@wallet.wallet_number}."
        redirect_to transactions_path, status: :created, content_type: "text/html", notice: "Top-up successful!"
      else
        flash[:alert_transaction] = transaction.errors.full_messages.join(", ")
        render :new
      end
    else
      flash[:alert_transaction] = "Wallet not found. Please create a wallet first."
      render :new
    end
  end



  private
  def wallet_params
    params.require(:wallet).permit(:wallet_number, :balance, :user_id)
  end
end
