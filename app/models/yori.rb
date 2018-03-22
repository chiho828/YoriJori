class Yori < ApplicationRecord
    belongs_to :user
    has_one :post
    has_many :recipes
    has_many :ingredients, through: :recipes
end
