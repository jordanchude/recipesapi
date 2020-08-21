class CategoryController < ApplicationController
  def index
    @categories = Category.all
    if @categories.empty?
      render :json => {
          :error => 'no categories found'
      }
    else
      render :json => {
          :response => 'successful',
          :data => @categories
      }
    end
  end

  def create
    @created_category = Category.new(category_params)
    if @created_category.save
      render  :json => {
          :response => 'successfully added category',
          :data => @created_category
      }
    else
      render :json => {
          :error => 'cannot save category'
      }
    end
  end

  def show
    @single_category = Category.exists?(params[:id])

    if @single_category
      render :json => {
          :response => 'successful',
          :data => Category.find(params[:id])
      }
    else
      render :json => {
          :error => 'category does not exist'
      }
    end
  end

  def update
    if (@single_category_update = Category.find_by_id(params[:id])).present?
      @single_category_update.update(category_params)
      render :json => {
          :response => 'successfully updated the selected category',
          :data => @single_category_update
      }
    else
      render :json => {
          :error => 'cannot update category'
      }
    end
  end

  def destroy
    if (@single_category_destroy = Category.find_by_id(params[:id])).present?
      @single_category_destroy.destroy
      render :json => {
          :response => 'successfully deleted the selected category',
          :data => @single_category_destroy
      }
    else
      render :json => {
          :error => 'category does not exist'
      }
    end
  end

  private
  def category_params
    params.permit(:title, :description, :created_by)
  end
end
