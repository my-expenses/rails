class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    transaction.transactionType = ActiveModel::Type::Boolean.new.cast(params[:type])
    if transaction.save
      render json: {
        status: :created,
        transaction: transaction
      }, status: :created
    else
      render json: {status: 500}, status: :internal_server_error
    end
  end

  def index
    transactions = Transaction.all
    render json: { transactions: transactions }
  end

  private
  def transaction_params
    params.permit(:amount, :transactionTitle, :date)
  end
end
