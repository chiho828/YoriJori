class PostsController < ApplicationController
    # Create post
    def new
    end
    
    # Save in DB
    def create
        ################test#######################
        
        # Add new yori
        @yori = Yori.new
        @yori.name = "닭도리탕"
        @yori.user_id = 10
        @yori.save
        
        # Add new post
        @post = Post.new
        @post.yori_id = @yori.id
        @post.subtitle = "test"
        @post.main = "닭 (100g), 고추장 (20g)"
        @post.optional = "양파 (50g), 감자 (50g)"
        @post.seasoning = "고춧가루 (3스푼)"
        @post.steps = ["step1", "step2", "step3"]
        @post.save
        
        @main_ingredient = ["닭", "고추장"]
        
        # add new recipe
        for item in @main_ingredient
            @recipe = Recipe.new
            @ingredient = Ingredient.find_by(name: item)
            @recipe.ingredient_id = @ingredient.id
            @recipe.yori_id = @yori.id
            @recipe.save
        end
        
        
        
        ##################complete####################
        
        # # Add new yori
        # @yori = Yori.new
        # @yori.name = params[:input_name]
        # @yori.user_id = ??? (get from login status)
        # @yori.save
        
        # # Add new post
        # @post = Post.new
        # @post.yori_id = @yori.id
        # @post.subtitle = params[:input_name]
        
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
        
        redirect_to '/posts/new'
    end
    
    # show all
    def index
        @yoris = Yori.all
    end
    
    # show specific post
    def show
        @yori = Yori.find(params[:yori_id])
        @post = Post.find_by(yori_id: @yori.id)
    end
end
