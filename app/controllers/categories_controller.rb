class CategoriesController < ApplicationController
  load_and_authorize_resource

  def index; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'Category created successfully!'
    else
      render :new, alert: 'Category was not created!'
    end
  end

  def destroy; end

  private

  def category_params
    category_params_hash = params.required(:category).permit(:name, :icon)
    category_params_hash[:author] = current_user
    category_params_hash
  end
end
