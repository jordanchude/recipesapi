class RecipesController < ApplicationController
  def index
    @all_recipes = Recipe.where(:category_id => params[:category_id])
    if @all_recipes.empty?
      render :json => {
          :error => 'there are no recipes'
      }
    else
      render :json => {
          :response => 'successful',
          :data => @all_recipes
      }
    end
  end

  def create
    @created_recipe = Recipe.new(recipe_params)
    if Category.exists?(@created_recipe.category_id)
      if @created_recipe.save
        render :json => {
            :response => 'successfully created recipe',
            :data => @created_recipe
        }
      else
        render :json => {
            :error => 'could not create recipe'
        }
      end
    else
      render :json => {
          :error => 'category for recipe does not exist'
      }
    end
  end

  def show
    @all_recipes = Recipe.where(:category_id => params[:category_id])
    @single_recipe = Recipe.exists?(params[:id])

    if @all_recipes.empty?
      render :json => {
          :error => 'the category you want to find a recipe for does not exist'
      }
    else
      if @single_recipe && Recipe.find(params[:id]).category_id == params[:category_id].to_i
        render :json => {
            :response => 'successful',
            :data => Recipe.find(params[:id])
        }
      else
        render :json => {
            :error => 'recipe not found'
        }
      end
    end
  end

  def update
    @all_recipes = Recipe.where(:category_id => params[:category_id])

    if @all_recipes.empty?
      render :json => {
          :error => 'the category you want to update a recipe for does not exist'
      }
    else
      if (@single_recipe_update = Recipe.find_by_id(params[:id])).present? && Recipe.find(params[:id]).category_id == params[:category_id].to_i
        @single_recipe_update.update(recipe_params)
        render :json => {
            :response => 'successfully updated the selected recipe',
            :data => @single_recipe_update
        }
      else
        render :json => {
            :error => 'recipe to update does not exist'
        }
      end
    end
  end

  def destroy
    @all_recipes = Recipe.where(:category_id => params[:category_id])

    if @all_recipes.empty?
      render :json => {
          :error => 'the category for the recipe you want to delete does not exist'
      }
    else
      if (@single_recipe_destroy = Recipe.find_by_id(params[:id])).present? && Recipe.find(params[:id]).category_id == params[:category_id].to_i
        @single_recipe_destroy.destroy
        render :json => {
            :response => 'the selected recipe has been deleted',
            :data => @single_recipe_destroy
        }
      else
        render :json => {
            :error => 'recipe does not exist'
        }
      end
    end
  end

  private
  def recipe_params
    params.permit(:category_id, :name, :ingredients, :directions, :notes, :tags)
  end
end
