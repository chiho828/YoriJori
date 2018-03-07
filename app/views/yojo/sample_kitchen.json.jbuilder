json.array!(@ingredients) do |ingredient|
  json.name        ingredient.name
end

json.array!(@seasonings) do |seasoning|
  json.name        seasoning.name
end