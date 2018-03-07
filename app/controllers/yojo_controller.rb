class YojoController < ApplicationController
    before_action :set_recipe, only: [:show, :edit, :update, :destroy]
    
    # root
    def index
        # get + show recommendations
    end

    # GET /recipes/1
    def show
    end
    
    # GET /recipes/new
    def new
        # recipe = Recipe.new
    end
    
    # GET /recipes/1/edit
    def edit
    end
    
    def sample_kitchen
        respond_to do |format|
            format.html
            if params[:id] == '1'
                format.json { @ingredients = Ingredient.search(params[:term]) }
            elsif params[:id] == '2'
                format.json { @seasonings = Seasoning.search(params[:term]) }
            end
        end
    end
    
    # POST /recipes
    def create
    end
    
    # PATCH/PUT /recipes/1
    def update
    end
    
    # DELETE /recipes/1
    def destroy
    end
    
    private
        def set_recipe
        end
        
        def recipe_params
        end
end