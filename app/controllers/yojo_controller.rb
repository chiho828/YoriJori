class YojoController < ApplicationController
    before_action :set_recipe, only: [:show, :edit, :update, :destroy]
    
    # root
    def index
        @yori = params[:yori]
        @id = params[:id]
        
        @type = 1
        if @yori != nil 
            @type = 2
        elsif @id != nil
            @type = 3
        end
            
        if @type == 2 and @yori != ""
            @yoris = Yori.where('name LIKE ?', "%#{@yori}%")
        elsif @type == 3 and @id != ""
            @user = User.where("username LIKE ?", "%#{@id}%")
            @yoris = Yori.where('user_id = ?', @user.ids)
        end
        
        respond_to do |format|
            format.html
            format.json { @ingredients = Ingredient.search(params[:term]) }
        end
        
         if @yoris != nil
            @items_page = 20
            @current_page = params[:page_number].to_i
            
            @max_items = @yoris.length
            @max_page = (Float(@max_items) / @items_page).ceil
           
            @posts = Post.where("yori_id": @yoris.ids).limit(@items_page).offset(@current_page*@items_page)
        end
    end
    
    def combine
        @basket = params[:data_value]
        
        @comp = Yori.joins(:recipes).where('recipes.main = "t" AND ingredient_id NOT IN (?)', @basket).group("yori_id")
        @yoris = Yori.where.not(id: @comp.ids)
    
        respond_to do |format|
            format.js
        end
        
        if @yoris != nil
            @items_page = 20
            @current_page = params[:page_number].to_i
            
            @max_items = @yoris.length
            @max_page = (Float(@max_items) / @items_page).ceil
           
            @posts = Post.where("yori_id": @yoris.ids).limit(@items_page).offset(@current_page*@items_page)
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
        
        @recommended = 9
        @basket = @kitchen.ingredients
        @comp = Yori.joins(:recipes).where('recipes.main = "t" AND ingredient_id NOT IN (?)', @basket).group("yori_id")
        @yoris = Yori.where.not(id: @comp.ids).limit(@recommended)
    end
    
    # POST
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

    # POST
    def post_yori
        @yori = Yori.new
        @yori.name = params[:title]
        @yori.user_id = params[:user]
        @yori.save
        
        @ingredients = params[:ingredients]
        @types = params[:types]
        @quantities = params[:quantities]
        @units = params[:units]
        for i in 0..@ingredients.length-1
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = @ingredients[i]
            if @types[i] == "1"
                @recipe.main = true
                @recipe.seasoning = true
            elsif @types[i] == "2"
                @recipe.main = true
                @recipe.seasoning = false
            elsif @types[i] == "3"
                @recipe.main = false
                @recipe.seasoning = true
            else
                @recipe.main = false
                @recipe.seasoning = false
            end
            @recipe.quantity = @quantities[i]
            @recipe.unit = @units[i]
            @recipe.save
        end
        
        @post = Post.new
        @post.yori_id = @yori.id
        @post.title = params[:title]
        @post.subtitle = params[:subtitle]
        @post.main = params[:main]
        @post.optional = params[:optional]
        @post.seasoning = params[:seasoning]
        @post.steps = params[:steps]
        @post.save
        
        logger.debug "test"
        logger.debug @yori.id
        render :js => "window.location = '/yojo/yori/#{@yori.id}'"
    end
    
    def yori
        @yori = Yori.find(params[:yori_id])
        @post = Post.find_by(yori_id: @yori.id)
        @user = User.find(@yori.user_id)
        @comments = Comment.where(post_id: @post.id)
    end
    
    def edit_yori
        @post = Post.find_by(yori_id: params[:yori_id])
        @ingredients = Yori.find(params[:yori_id]).ingredients
    end
    
    # POST (could depend)
    def update_yori
        @yori = Yori.find(params[:yori_id])
        @yori.name = params[:title]
        @yori.save
        
        @trash = @yori.recipes
        @trash.each do |i|
            i.destroy
        end
        
        @ingredients = params[:ingredients]
        @types = params[:types]
        @quantities = params[:quantities]
        @units = params[:units]
        for i in 0..@ingredients.length-1
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = @ingredients[i]
            if @types[i] == "1"
                @recipe.main = true
                @recipe.seasoning = true
            elsif @types[i] == "2"
                @recipe.main = true
                @recipe.seasoning = false
            elsif @types[i] == "3"
                @recipe.main = false
                @recipe.seasoning = true
            else
                @recipe.main = false
                @recipe.seasoning = false
            end
            @recipe.quantity = @quantities[i]
            @recipe.unit = @units[i]
            @recipe.save
        end
        
        @post = @yori.post
        @post.title = params[:title]
        @post.subtitle = params[:subtitle]
        @post.main = params[:main]
        @post.optional = params[:optional]
        @post.seasoning = params[:seasoning]
        @post.steps = params[:steps]
        @post.save
        
        render :js => "window.location = '/yojo/yori/#{@yori.id}'"
    end
    
    # DELETE
    def destroy_yori
    end
    
    def yori_book
        @items_page = 4
        @current_page = params[:page_number].to_i
        
        @user = User.find(current_user.id)
        @posts = Post.joins(:yori).where("yoris.user_id": @user.id).limit(@items_page).offset(@current_page*@items_page)
        @yoris = @user.yoris
        @max_page = (Float(@yoris.length) / @items_page).ceil
    end
    
    
    private
        def set_recipe
        end
        
        def recipe_params
        end
        
        def getCurrentPageYoriItems
        end
    
    # USER
    def show
        @user = User.find(params[:id])
    end

end