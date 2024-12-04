class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    source_wallet = Wallet.find_by(wallet_number: @transaction.source_wallet_number)
    target_wallet = Wallet.find_by(wallet_number: @transaction.target_wallet_number)

    source_wallet.update(balance: source_wallet.balance - @transaction.amount)
    target_wallet.update(balance: target_wallet.balance + @transaction.amount)

    if source_wallet && target_wallet
      if source_wallet.balance >= @transaction.amount
        @transaction.save
        redirect_to transactions_path, notice: "Transaction created successfully."
      else
        redirect_to transactions_new_path, alert: "Insufficient balance."
      end
    else
      redirect_to transactions_new_path, alert: "Wallet not found."
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:source_wallet_number, :target_wallet_number, :amount, :transaction_type, :notes)
  end
end
