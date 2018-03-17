class Post < ApplicationRecord
    belongs_to :user
    serialize :steps, Array
end
