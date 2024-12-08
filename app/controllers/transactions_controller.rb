class TransactionsController < ApplicationController
  def index
    if session[:user_id]
      @transactions = Transaction.where(user_id: session[:user_id])
      @user = User.find(session[:user_id])
    else
      redirect_to login_path
    end
  end

  def new
    if session[:user_id]
      @transaction = Transaction.new
    else
      redirect_to login_path
    end
  end

  def create
    @transaction = Transaction.new(transaction_params)

    source_wallet = Wallet.find_by(user_id: session[:user_id])
    target_wallet = Wallet.find_by(wallet_number: @transaction.target_wallet_id)

    if target_wallet.nil?
      flash.now[:alert_transaction] = "Target wallet not found."
      render :new, status: :unprocessable_entity, notice: @transaction.errors.full_messages.join(", ")
    else
      @transaction.source_wallet_id = source_wallet.id
      @transaction.target_wallet_id = target_wallet.id

      if source_wallet.balance < @transaction.amount
        flash[:alert_transaction] = "Insufficient balance."
        render :new, status: :unprocessable_entity, notice: @transaction.errors.full_messages.join(", ")
      else
        source_wallet.balance = source_wallet.balance - @transaction.amount
        Wallet.where(wallet_number: source_wallet.wallet_number).update_all(balance: source_wallet.balance)

        target_wallet.balance = target_wallet.balance + @transaction.amount
        Wallet.where(wallet_number: target_wallet.wallet_number).update_all(balance: target_wallet.balance)

        @transaction.transaction_type = "transfer"
        @transaction.user_id = session[:user_id]

        if @transaction.save
          flash[:notice_transaction] = "Transfer successful!"
          redirect_to transactions_path and return
        else
          puts "@transaction.errors.full_messages"
          flash[:alert_transaction] = @transaction.errors.full_messages.join(", ")
          render :new, status: :unprocessable_entity, notice: @transaction.errors.full_messages.join(", ")
        end
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
