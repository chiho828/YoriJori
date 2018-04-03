class Post < ApplicationRecord
    # mount_uploader :image, ImageUploader
    
    belongs_to :yori
    serialize :steps, Array
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :scraps, dependent: :destroy
    has_many :users, through: :likes
    has_many :users, through: :scraps
end