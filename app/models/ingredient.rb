class Ingredient < ApplicationRecord
    has_many :recipes
    has_many :yoris, through: :recipes
    
    def self.search(term)
        where('name LIKE ?', "%#{term}%")
    end
end
