class Ingredient < ApplicationRecord
    def self.search(term)
        where('name LIKE :term', term: "%#{term}%")
    end
end
