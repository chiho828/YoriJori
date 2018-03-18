class YojoController < ApplicationController
    before_action :set_recipe, only: [:show, :edit, :update, :destroy]
    
    def test
        @yori = params[:yori]
        @id = params[:id]
        
        @type = 1
        if @yori != nil 
            @type = 2
        elsif @id != nil
            @type = 3
        end
            
        if @type == 2 and @yori != ""
            @results = Yori.where('name LIKE ?', "%#{@yori}%")
        elsif @type == 3 and @id != ""
            @user = User.where("username LIKE ?", "%#{@id}%")
            @results = Yori.where('user_id = ?', @user.ids)
        end
        
        respond_to do |format|
            format.html
            format.json { @ingredients = Ingredient.search(params[:term]) }
        end
    end
    
    def combine
        @basket = params[:data_value]
        
        @comp = Yori.joins(:recipes).where.not("recipes.ingredient_id": @basket)
        @yoris = Yori.where.not(id: @comp.ids)
    
        respond_to do |format|
            format.js
        end
    end
    
    def switch
        @type = params[:data_value]
        
        respond_to do |format|
            format.js
        end
    end
    
    def kitchen
        if user_signed_in?
            @user = current_user
            @kitchen = @user.kitchen
        end
    end
    
    def addIngredients
        @user = User.find(params[:user])
        @kitchen = @user.kitchen
        
        if @user.kitchen == nil
            @kitchen = Kitchen.new
            @kitchen.user_id = @user.id
        end
        
        @kitchen.ingredients = params[:list]
        @kitchen.save
        
        render :js => "window.location = '/yojo/kitchen'"
    end
    
    # root
    def index
        # get + show recommendations
        @yori = params[:yori]
        @id = params[:id]
        
        @type = 1
        if @yori != nil 
            @type = 2
        elsif @id != nil
            @type = 3
        end
            
        if @type == 2 and @yori != ""
            @results = Yori.where('name LIKE ?', "%#{@yori}%")
        elsif @type == 3 and @id != ""
            @user = User.where("username LIKE ?", "%#{@id}%")
            @results = Yori.where('user_id = ?', @user.ids)
        end
        
        respond_to do |format|
            format.html
            format.json { @ingredients = Ingredient.search(params[:term]) }
        end
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
    
    # POST /recipes
    def create
    end
    
    # PATCH/PUT /recipes/1
    def update
    end
    
    # DELETE /recipes/1
    def destroy
    end
    
    def yori
        @post = Post.find(35)
    end
    
    def yori_book
       
    end
    
    private
        def set_recipe
        end
        
        def recipe_params
        end
        
    #     def 
    #         store_current_location
    #         store_location_for(:user, request.url)
    #     end
        
    #     private
    #     def after_sign_out_path_for(resource)
    #             request.referrer || root_path
    #     end
        
    #     private
    #     def 
    #         after_sign_in_path_for(resource)
    #         session["user_return_to"] || root_path
    #     end
        
 

end