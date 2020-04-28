class Post < ApplicationRecord
    has_one_attached :main_image
    
    belongs_to :yori
    serialize :steps, Array
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :scraps, dependent: :destroy
end