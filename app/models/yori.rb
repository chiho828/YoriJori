class Yori < ApplicationRecord
    belongs_to :user
    has_one :post, dependent: :destroy
    has_many :recipes, dependent: :destroy
    has_many :ingredients, through: :recipes
end
