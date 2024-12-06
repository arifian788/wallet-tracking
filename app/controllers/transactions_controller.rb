class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.where(source_wallet_id: session[:user_id])
    @user = User.find(session[:user_id])
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    source_wallet = Wallet.find_by(user_id: @transaction.source_wallet_id)
    target_wallet = Wallet.find_by(wallet_number: @transaction.target_wallet_id)

    if target_wallet.nil?
      flash.now[:alert_transaction] = "Target wallet not found."
      return render :new
    end

    @transaction.source_wallet_id = source_wallet.id
    @transaction.target_wallet_id = target_wallet.id

    if source_wallet.balance < @transaction.amount
      flash.now[:alert_transaction] = "Insufficient balance."
      render :new
    else
      source_wallet.balance -= @transaction.amount
      target_wallet.balance += @transaction.amount

      if source_wallet.save && target_wallet.save && @transaction.save
        flash[:notice_transaction] = "Transaction successful!"
        redirect_to transactions_path
      else
        flash[:alert_transaction] = "Transaction failed. Please try again."
        render :new
      end
    end
  end


  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    flash[:notice_transaction] = "Transaction deleted successfully!"
    redirect_to transactions_path
  end

  private
  def transaction_params
    params.require(:transaction).permit(:wallet_number, :target_wallet_id, :amount, :transaction_type, :notes)
  end
end
