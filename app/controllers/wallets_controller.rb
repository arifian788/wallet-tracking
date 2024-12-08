class WalletsController < ApplicationController
  def new
    if session[:user_id]
      @wallet = Wallet.new
      @user = User.find(session[:user_id])
      @wallet = Wallet.where(user_id: @user.id)
    else
      redirect_to login_path
    end
  end

  def create
    wallet = Wallet.create(
      wallet_number: rand(10**9..10**10 - 1),
      balance: 0,
      user_id: session[:user_id]
    )

    flash[:notice_transaction] = "Wallet created successfully! Your wallet number is #{wallet.wallet_number}."
    redirect_to transactions_path and return
  end

  def topup
    @user = User.find(session[:user_id])
    @wallet = Wallet.where(user_id: @user.id, wallet_number: params[:wallet][:wallet_number]).first

    if @wallet
      balance_wallet = @wallet.balance.to_i + params[:wallet][:amount].to_i
      @wallet.update(wallet_number: params[:wallet][:wallet_number], balance: balance_wallet)

      transaction = Transaction.create(
        source_wallet_id: @wallet.id,
        amount: params[:wallet][:amount],
        user_id: @wallet.user_id,
        transaction_type: "topup",
        notes: params[:wallet][:notes]
      )

      if transaction.save
        flash[:notice_transaction] = "Top-up successful! Your wallet number is #{@wallet.wallet_number}."
        redirect_to transactions_path and return
      else
        flash[:alert_transaction] = transaction.errors.full_messages.join(", ")
        render :new and return
      end
    end
  end

  private
  def wallet_params
    params.require(:wallet).permit(:wallet_number, :balance, :user_id)
  end
end
