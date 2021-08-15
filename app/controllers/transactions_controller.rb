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
    start_of_month = DateTime.parse(params[:month]).at_beginning_of_month
    end_of_month = DateTime.parse(params[:month]).at_end_of_month
    page = params[:page].to_i
    limit = params[:itemsPerPage].to_i
    offset = (page - 1) * limit
    transactions = Transaction.where(user_id: get_user_id)
                              .where(date: start_of_month..end_of_month) # between clause
                              .offset(offset)
                              .limit(limit)
    render json: { transactions: transactions }
  end

  def update
    transaction = Transaction.where(ID: params[:id], user_id: get_user_id).first
    if !transaction # transaction not found
      render json: { status: 404 }, status: :not_found
    else
      transaction.transactionType = ActiveModel::Type::Boolean.new.cast(params[:type])
      if transaction.update(transaction_params)
        render json: { transaction: transaction }
      else
        render json: { status: 500, message: transaction.errors.full_messages }, status: :internal_server_error
      end
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
    start_of_month = DateTime.parse(params[:month]).at_beginning_of_month
    end_of_month = DateTime.parse(params[:month]).at_end_of_month
    records_array = Transaction
                      .select("categoryID")
                      .where(date: start_of_month..end_of_month)
                      .group("categoryID").pluck(:categoryID, Arel.sql('SUM(CASE WHEN transactionType = 1 THEN amount ELSE -amount END) AS total'))
                      .map { |categoryID, total| { categoryID: categoryID, total: total } }
    render json: { groupedTransactions: records_array }
  end

  private

  def transaction_params
    params.permit(:amount, :transactionTitle, :date, :categoryID)
  end
end
