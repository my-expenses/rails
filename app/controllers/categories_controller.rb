class CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: { categories: categories }
  end

  def create
    category = Category.new(category_params)
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
    category = Category.find(params[:id])
    if category.update(category_params)
      render json: { category: category }
    else
      render json: { status: 500 }, status: :internal_server_error
    end
  end

  def destroy
    category = Category.find(params[:id])
    if category.destroy
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
