class CategoriesController < ApplicationController
  def index
    categories = Category.where(user_id: get_user_id)
    render json: { categories: categories }
  end

  def create
    category = Category.new(category_params)
    category.user_id = get_user_id
    if category.save
      render json: {
        status: :created,
        category: category
      }, status: :created
    else
      render json: { status: 500 }, status: :internal_server_error
    end
  end

  def update
    category = Category.where(ID: params[:id], user_id: get_user_id)
    if category.empty?
      render json: { status: 404 }, status: :not_found
    elsif category.update(category_params)
      render json: { category: category }
    else
      render json: { status: 500 }, status: :internal_server_error
    end
  end

  def destroy
    category = Category.where(ID: params[:id], user_id: get_user_id)
    if category.empty?
      render json: { status: 404 }, status: :not_found
    elsif category.destroy(params[:id])
      render json: { message: "success" }
    else
      render json: { status: 500 }, status: :internal_server_error
    end
  end

  private

  def category_params
    params.permit(:title)
  end
end
