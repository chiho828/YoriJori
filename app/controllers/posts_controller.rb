class PostsController < ApplicationController
    # Create post
    def new
    end
    
    # Save in DB
    def create
        
        # @yori = Yori.new
        # @yori.name = params[:title]
        # @yori.user_id = params[:user]
        # @yori.save
        
        # @ingredients = params[:ingredients]
        # @types = params[:types]
        # @quantities = params[:quantities]
        # @units = params[:units]
        # for i in 0..@ingredients.length-1
        #     @recipe = Recipe.new
        #     @recipe.yori_id = @yori.id
        #     @recipe.ingredient_id = @ingredients[i]
        #     if @types[i] == "1"
        #         @recipe.main = true
        #         @recipe.seasoning = true
        #     elsif @types[i] == "2"
        #         @recipe.main = true
        #         @recipe.seasoning = false
        #     elsif @types[i] == "3"
        #         @recipe.main = false
        #         @recipe.seasoning = true
        #     else
        #         @recipe.main = false
        #         @recipe.seasoning = false
        #     end
        #     @recipe.quantity = @quantities[i]
        #     @recipe.unit = @units[i]
        #     @recipe.save
        # end
        
        # @post = Post.new
        # @post.yori_id = @yori.id
        # @post.title = params[:title]
        # @post.subtitle = params[:subtitle]
        # @post.main = params[:main]
        # @post.optional = params[:optional]
        # @post.seasoning = params[:seasoning]
        # @post.steps = params[:steps]
        # @post.save
        
        # render :js => "window.location = '/posts/show/#{@yori.id}'"
    end
    
    
    
    # show all
    def index
        @yoris = Yori.all
    end
    
    
    
    # show specific post
    def show
        
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
    
    
    # directs to edit page
    def edit
        @post = Post.find_by(yori_id: params[:yori_id])
        @ingredients = Yori.find(params[:yori_id]).ingredients
    end
    
    
    # update specific post    
    def update
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
        
        render :js => "window.location = '/posts/show/#{@yori.id}'"
    end
    
    
    # delete data from multiple tables: yoris, recipes, posts
    def destroy
        @yori = Yori.find(params[:yori_id])
        @yori.destroy
        
        redirect_to "/posts/index"
    end
end