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
        if @basket == nil
            @basket = [0]
        end
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
        @likes = []
        @scraps = []
        if user_signed_in?
            @likes = Like.where('user_id = ? AND post_id = ?', current_user.id, @post.id)
            @scraps = Scrap.where('user_id = ? AND post_id = ?', current_user.id, @post.id)
        end
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
        @yori = Yori.find(params[:yori_id])
        @yori.destroy
        redirect_to "/yojo/yori_book/#{current_user.id}"
    end
    
    # POST (could depend)
    def kitchen
        @kitchen_user = User.find(params[:user_id])
        @kitchen = @kitchen_user.kitchen
        
        if @kitchen_user.id == current_user.id 
            if @kitchen == nil
                @kitchen = Kitchen.new
                @kitchen.user_id = current_user.id
                @kitchen.save
            end
            
            # @recommended = 9
            # @basket = @kitchen.ingredients
            # if @basket.length == 0
            #     @basket = [0]
            # end
            # @comp = Yori.joins(:recipes).where('recipes.main = "t" AND ingredient_id NOT IN (?)', @basket).group("yori_id")
            # @yoris = Yori.where.not(id: @comp.ids).limit(@recommended)
        end
        
        @recommended = 9
        if @kitchen != nil
            @basket = @kitchen.ingredients
            if @basket.length == 0
                @basket = [0]
            end
            @comp = Yori.joins(:recipes).where('recipes.main = "t" AND ingredient_id NOT IN (?)', @basket).group("yori_id")
            @yoris = Yori.where.not(id: @comp.ids).limit(@recommended)
        end
        
        @follows = []
        @follows = Follow.where(follower_id: current_user.id, followee_id: @kitchen_user.id)
        
        @posts = @kitchen_user.posts
        @followers  = @kitchen_user.followers
        @followees = @kitchen_user.followees
        
        @likes = 0
        @posts.each do |post|
            @likes += post.likes.length
        end
    end
    
    # POST
    def addIngredients
        @kitchen = current_user.kitchen
        @kitchen.ingredients = params[:list]
        @kitchen.save
        
        render :js => "window.location = '/yojo/kitchen/#{current_user.id}'"
    end
    
    def yori_book
        @items_page = 4
        @current_page = 0
        @user = User.find(params[:user_id])
        
        @posts = Post.where(id: @user.posts.ids).limit(@items_page).offset(@current_page*@items_page)
        @max_page = (Float(@user.yoris.length) / @items_page).ceil
    end
    
    def booktab
        @items_page = 4
        @tab = params[:tab].to_i
        @current_page = params[:page_number].to_i
        @user = User.find(params[:user_id])
        
        if @tab == 1
            @posts = Post.where(id: @user.posts.ids).limit(@items_page).offset(@current_page*@items_page)
            @max_page = (Float(@user.yoris.length) / @items_page).ceil
        end
        
        if @tab == 2
            @scraps = @user.scraps
            @scrap_posts = []
            @scraps.each do |s|
                @scrap_posts.push(s.post_id)
            end
            
            @posts = Post.where(id: @scrap_posts).limit(@items_page).offset(@current_page*@items_page)
            @max_page = (Float(@scraps.length) / @items_page).ceil
        end
        
        if @tab == 3
            @posts = Post.joins(:yori).where("yoris.user_id": @user.followees.ids).limit(@items_page).offset(@current_page*@items_page)
            @total_posts = Post.joins(:yori).where("yoris.user_id": @user.followees.ids)
            @max_page = (Float(@total_posts.length) / @items_page).ceil
        end
        
        respond_to do |format|
            format.js
        end
    end
    
    def like
        @like = Like.new
        @like.user_id = params[:user_id]
        @like.post_id = params[:post_id]
        @like.save
        # render :js => "window.location = '/yojo/yori/#{params[:post_id]}'"
    end
    
    @DELETE
    def unlike
        Like.destroy(params[:like_id])
        # render :js => "window.location = '/yojo/yori/#{params[:post_id]}'"
    end
    
    def scrap
        @scrap = Scrap.new
        @scrap.user_id = params[:user_id]
        @scrap.post_id = params[:post_id]
        @scrap.save
        # render :js => "window.location = '/yojo/yori/#{params[:post_id]}'"
    end
    
    # DELETE
    def unscrap
        Scrap.destroy(params[:scrap_id])
        # render :js => "window.location = '/yojo/yori/#{params[:post_id]}'"
    end
    
    def follow
        @follow = Follow.new
        @follow.follower_id = params[:follower_id]
        @follow.followee_id = params[:followee_id]
        @follow.save
        # render :js => "window.location = '/yojo/kitchen/#{params[:followee_id]}'"
    end
    
    # DELETE
    def unfollow
        Follow.destroy(params[:follow_id])
        # render :js => "window.location = '/yojo/kitchen/#{params[:kitchen_user_id]}'"
    end
    
     # USER
    def show
        @user = User.find(params[:user_id])
    end
    
    private
        def set_recipe
        end
        
        def recipe_params
        end
end