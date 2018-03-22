class PostsController < ApplicationController
    # Create post
    def new
    end
    
    # Save in DB
    def create
        ################test#######################
        
        # # Add new yori
        # @yori = Yori.new
        # @yori.name = "닭도리탕"
        # @yori.user_id = 10
        # @yori.save
        
        # # Add new post
        # @post = Post.new
        # @post.yori_id = @yori.id
        # @post.subtitle = "test"
        # @post.main = "닭 (100g), 고추장 (20g)"
        # @post.optional = "양파 (50g), 감자 (50g)"
        # @post.seasoning = "고춧가루 (3스푼)"
        # @post.steps = ["step1", "step2", "step3"]
        # @post.save
        
        # @main_ingredient = ["닭", "고추장"]
        
        # # add new recipe
        # for item in @main_ingredient
        #     @recipe = Recipe.new
        #     @ingredient = Ingredient.find_by(name: item)
        #     @recipe.ingredient_id = @ingredient.id
        #     @recipe.yori_id = @yori.id
        #     @recipe.save
        # end
        
        ######################치호############################
        
        @yori = Yori.new
        @yori.name = params[:title]
        @yori.user_id = params[:user]
        @yori.save
        
        @ingredients = params[:ingredients]
        @ingredients.each do |i|
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = i
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
        
        
        ##################complete####################
        
        # # Add new yori
        # @yori = Yori.new
        # @yori.name = params[:input_name]
        # @yori.user_id = ??? (get from login status)
        # @yori.save
        
        # # Add new post
        # @post = Post.new
        # @post.yori_id = @yori.id
        # @post.subtitle = params[:input_subtitle]
        
        # # If input ingredient is "main"
        # @main_ingredient = []
        
        # # If input ingredient is "seasoning"
        # @seasoning = []
        
        # # If input ingredient is "none of the above"
        # @optional_ingredient = []
        
        # # save steps in array
        # @steps = []
        
        # # Concat to string
        # @result_main = ""
        # for main in @main_ingredient
        #     @result_main = main + "(" + params[:size] + ")" + params[:unit] + ", "
        # end
        
        # # Concat to string
        # @result_optional = ""
        # for optional in @optional_ingredient
        #     @result_optional = optional + "(" + params[:size] + ")" + params[:unit] + ", "
        # end
        
        # # Concat to string
        # @result_seasoning = ""
        # for season in @seasoning
        #     @result_seasoning = season + "(" + params[:size] + ")" + params[:unit] + ", "
        # end
        
        
        # @post.main = @result_main
        # @post.optional = @result_optional
        # @post.seasoning = @result_seasoning
        # @post.steps = @steps
        # @post.save
        
        # add new recipe
        # for item in @main_ingredient
        #     @recipe = Recipe.new
        #     @ingredient = Ingredient.find_by(name: item)
        #     @recipe.ingredient_id = @ingredient.id
        #     @recipe.yori_id = @yori.id
        #     @recipe.save
        # end
        
        
        # redirect does not work. maybe javascript?
        redirect_to "/posts/show/#{@yori.id}"
    end
    
    
    
    # show all
    def index
        @yoris = Yori.all
    end
    
    
    
    # show specific post
    def show
        # @count = 1
        @yori = Yori.find(params[:yori_id])
        @post = Post.find_by(yori_id: @yori.id)
        # logger.debug @post.steps
        @comments = Comment.where(post_id: @post.id)
    end
    
    
    # directs to edit page
    def edit
        @yori = Yori.find(params[:yori_id])
        @post = Post.find_by(yori_id: @yori.id)
    end
    
    
    # update specific post    
    def update
        # NEED TO CHECK USER ID
        
        @yori = Yori.find(params[:yori_id])
        @yori.name = params[:title]
        @yori.user_id = params[:user]
        @yori.save
        
        
        # WHAT IF USER CHANGES FROM 2 MAIN INGREDIENTS TO 3 MAIN INGREDIENTS?
        
        # first, delete previous recipes
        Recipe.where('yori_id = ?', @yori.id).find_each do |recipe|
            # puts recipe.id
            recipe.destroy
        end
        
        # then add new recipes with same yori.id
        # (호진쌤이 말씀하신 문제... 기존의 데이터를 지우고 다시 새로 만드는 inefficiency)
        @ingredients = params[:ingredients]
        @ingredients.each do |i|
            @recipe = Recipe.new
            @recipe.yori_id = @yori.id
            @recipe.ingredient_id = i
            @recipe.save
        end
        
        @post = Post.find_by(yori_id: @yori.id)
        # @post.yori_id = @yori.id
        @post.title = params[:title]
        @post.subtitle = params[:subtitle]
        @post.main = params[:main]
        @post.optional = params[:optional]
        @post.seasoning = params[:seasoning]
        @post.steps = params[:steps]
        @post.save
        
        # redirect does not work. maybe javascript?
        redirect_to "/posts/show/#{@yori.id}"
    end
    
    
    # delete data from multiple tables: yoris, recipes, posts
    def destroy
        
        # NEED TO CHECK USER ID
        
        @yori = Yori.find(params[:yori_id])
        # @post = Post.find_by(yori_id: @yori.id)
        
        # # is this a good style for large db?
        # Recipe.where('yori_id = ?', @yori.id).find_each do |recipe|
        #     # puts recipe.id
        #     recipe.destroy
        # end
        
        @yori.destroy
        # @post.destroy
        
        redirect_to "/posts/index"
    end
end
