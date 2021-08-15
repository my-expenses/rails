class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    transaction.user_id = get_user_id
    transaction.transactionType = ActiveModel::Type::Boolean.new.cast(params[:type])
    if transaction.save
      render json: {
        status: :created,
        transaction: transaction
      }, status: :created
    else
      render json: { status: 500, message: transaction.errors.full_messages }, status: :internal_server_error
    end
  end

  def index
    transactions = Transaction.where(user_id: get_user_id)
    render json: { transactions: transactions }
  end

  def update
    transaction = Transaction.where(ID: params[:id], user_id: get_user_id)
    transaction.transactionType = ActiveModel::Type::Boolean.new.cast(params[:type])
    if transaction.empty?
      render json: { status: 404 }, status: :not_found
    elsif transaction.update(transaction_params)
      render json: { transaction: transaction }
    else
      render json: { status: 500, message: transaction.errors.full_messages }, status: :internal_server_error
    end
  end

  def destroy
    transaction = Transaction.where(ID: params[:id], user_id: get_user_id)
    if transaction.empty?
      render json: { status: 404 }, status: :not_found
    elsif transaction.destroy(params[:id])
      render json: { message: "success" }
    else
      render json: { status: 500, message: transaction.errors.full_messages }, status: :internal_server_error
    end
  end

  def grouped
    records_array = Transaction
                      .select("categoryID")
                      .group("categoryID").pluck(:categoryID, Arel.sql('SUM(CASE WHEN transactionType = 1 THEN amount ELSE -amount END) AS total'))
                      .map { |categoryID, total| { categoryID: categoryID, total: total } }
    render json: { groupedTransactions: records_array }
  end

  private

  def transaction_params
    params.permit(:amount, :transactionTitle, :date, :categoryID)
  end
end
