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
           
        @date = params[:search_date]
        @beginning = nil
        if @date == "오늘"
            @beginning = Time.zone.now
        elsif @date == "이번주"
            @beginning = 1.week.ago
        elsif @date == "이번달"
            @beginning = 1.month.ago
        end
        
        if @type == 2 and @yori != ""
            if @beginning == nil
                @yoris = Yori.where('name LIKE ?', "%#{@yori}%")
            else
                @yoris = Yori.where('name LIKE ?', "%#{@yori}%").where(created_at: @beginning.beginning_of_day..Time.zone.now.end_of_day)
            end
        elsif @type == 3 and @id != ""
            @user = User.where("username LIKE ?", "%#{@id}%")
            if @beginning == nil
                @yoris = Yori.where('user_id IN (?)', @user.ids)
            else
                @yoris = Yori.where('user_id IN (?)', @user.ids).where(created_at: @beginning.beginning_of_day..Time.zone.now.end_of_day)
            end
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
           
            @posts = Post.where("yori_id": @yoris.ids).order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
        end
        
        @rec_likes = Post.order(like_count: :desc, created_at: :desc).limit(4)
        @rec_dates = Post.order("created_at DESC").limit(4)
    end
    
    def combine
        @basket = params[:data_value]

        @comp = Yori.joins(:recipes).where('recipes.main = true AND ingredient_id NOT IN (?)', @basket).group("yori_id")
      
        @date = params[:search_date]
        if @date == "all"
            @yoris = Yori.where.not(id: @comp.ids)
        else
            @beginning = nil
            if @date == "today"
                @beginning = Time.zone.now
            elsif @date == "last week"
                @beginning = 1.week.ago
            else
                @beginning = 1.month.ago
            end
            @yoris = Yori.where.not(id: @comp.ids).where(created_at: @beginning.beginning_of_day..Time.zone.now.end_of_day)
        end
    
        respond_to do |format|
            format.js
        end
        
        @items_page = 20
        @current_page = params[:page_number].to_i

        @max_items = @yoris.length
        @max_page = (Float(@max_items) / @items_page).ceil
        
        @posts = Post.where(yori_id: @yoris).order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
        @rec_likes = Post.order(like_count: :desc, created_at: :desc).limit(4)
        @rec_dates = Post.order("created_at DESC").limit(4)
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
        
        @ingredients = JSON.parse(params[:ingredients])
        @types = JSON.parse(params[:types])
        @quantities = JSON.parse(params[:quantities])
        @units = JSON.parse(params[:units])
        
        for i in 0..@ingredients.length-1
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = @ingredients[i]
            if @types[i] == 1
                @recipe.main = true
                @recipe.seasoning = true
            elsif @types[i] == 2
                @recipe.main = true
                @recipe.seasoning = false
            elsif @types[i] == 3
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
        @post.steps = JSON.parse(params[:steps])
        @post.main_image.attach(params[:image])
        @post.save
        
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

            @liked = @likes.any?
            @scrapped = @scraps.any?
        end
        @comments = Comment.where(post_id: @post.id)
        # @commenter = User.find(@comment.user_id)
        
        @post_likes = Like.where('post_id = ?', @post.id)
        @post_scraps = Scrap.where('post_id = ?', @post.id)
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

        @ingredients = JSON.parse(params[:ingredients])
        @types = JSON.parse(params[:types])
        @quantities = JSON.parse(params[:quantities])
        @units = JSON.parse(params[:units])

        for i in 0..@ingredients.length-1
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = @ingredients[i]
            if @types[i] == 1
                @recipe.main = true
                @recipe.seasoning = true
            elsif @types[i] == 2
                @recipe.main = true
                @recipe.seasoning = false
            elsif @types[i] == 3
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
        @post.steps = JSON.parse(params[:steps])
        @post.main_image.attach(params[:image]) if params[:image].present?
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
        end
        
        @recommended = 9
        if @kitchen != nil
            @basket = @kitchen.ingredients
            if @basket.length == 0
                @basket = [0]
            end
            @comp = Yori.joins(:recipes).where('recipes.main = true AND ingredient_id NOT IN (?)', @basket).group("yori_id")
            @yoris = Yori.where.not(id: @comp.ids).order("created_at DESC").limit(@recommended)
        end
        
        @follows = []
        @follows = Follow.where(follower_id: current_user.id, followee_id: @kitchen_user.id)
        
        @posts = @kitchen_user.posts
        @followers  = @kitchen_user.followers
        @followees = @kitchen_user.followees
        
        @likes = 0
        @posts.each do |post|
            @likes += post.like_count
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
        
        @posts = @user.posts.order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
        @max_page = (Float(@user.yoris.count) / @items_page).ceil
    end
    
    def booktab
        @items_page = 4
        @tab = params[:tab].to_i
        @current_page = params[:page_number].to_i
        @user = User.find(params[:user_id])
        
        if @tab == 1
            @posts = @user.posts.order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
            @max_page = (Float(@user.yoris.count) / @items_page).ceil
        end
        
        if @tab == 2
            @scraps = @user.scraps
            @scrap_posts = []
            @scraps.each do |s|
                @scrap_posts.push(s.post_id)
            end
            
            @posts = Post.where(id: @scrap_posts).order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
            @max_page = (Float(@scraps.length) / @items_page).ceil
        end
        
        if @tab == 3
            @posts = Post.joins(:yori).where("yoris.user_id": @user.followees.ids).order("created_at DESC").limit(@items_page).offset(@current_page*@items_page)
            @total_posts = Post.joins(:yori).where("yoris.user_id": @user.followees.ids)
            @max_page = (Float(@total_posts.length) / @items_page).ceil
        end
        
        respond_to do |format|
            format.js
        end
    end
    
    # POST/DELETE
    def like
        @user = User.find(params[:user_id])
        @post = Post.find(params[:post_id])
        
        @likes = []
        if user_signed_in?
            @likes = Like.where('user_id = ? AND post_id = ?', current_user.id, @post.id)
        end

        if @likes.any?
            @likes[0].destroy
            @liked = false
            @post.update_columns(like_count: @post.like_count-1)
        else
            @like = Like.new
            @like.user_id = @user.id
            @like.post_id = @post.id
            @like.save
            @liked = true
            @post.update_columns(like_count: @post.like_count+1)
        end
            
        @post_likes = Like.where('post_id = ?', @post.id)

        respond_to do |format|
            format.js
        end
    end
    
    # POST/DELETE
    def scrap
        @user = User.find(params[:user_id])
        @post = Post.find(params[:post_id])
        
        @scraps = []
        if user_signed_in?
            @scraps = Scrap.where('user_id = ? AND post_id = ?', current_user.id, @post.id)
        end
            
        if @scraps.any?
            @scraps[0].destroy
            @scrapped = false
        else
            @scrap = Scrap.new
            @scrap.user_id = @user.id
            @scrap.post_id = @post.id
            @scrap.save
            @scrapped = true
        end
            
        @post_scraps = Scrap.where('post_id = ?', @post.id)      
        
        respond_to do |format|
            format.js
        end
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
    
    private
        def set_recipe
        end
        
        def recipe_params
        end
end