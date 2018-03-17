class Post < ApplicationRecord
    belongs_to :yori
    serialize :steps, Array
end