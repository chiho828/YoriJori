class Post < ApplicationRecord
    belongs_to :yori
    serialize :steps, Array
    has_many :comments, dependent: :destroy
end