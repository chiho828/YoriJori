class CreateYorisJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    user = User.first
    ing_count = Ingredient.count
    default_image = File.open('public/default-placeholder.png')

    for i in 1..100000 do
      yori = Yori.create!(name: "Yori#{i}", user_id: user.id)
      ingredients = []

      3.times do
        ingredient_id = rand(ing_count)+1
        ingredient_id = rand(ing_count)+1 while ingredients.include?(ingredient_id)
        ingredients.push(ingredient_id)

        Recipe.create!(
          yori_id: yori.id,
          ingredient_id: ingredient_id,
          main: true,
          seasoning: false,
          quantity: 100,
          unit: 'g'
        )
      end

      post = Post.create!(
        yori_id: yori.id,
        title: yori.name,
        subtitle: 'description',
        main: yori.ingredients.pluck(:name).join(', '),
        steps: ['step1', 'step2', 'step3']
      )
      
      if i == 1
        post.main_image.attach(io: default_image, filename: 'default.png')
        default_image = post.main_image.blob
      else
        post.main_image.attach(default_image)
      end
    end
  end
end
