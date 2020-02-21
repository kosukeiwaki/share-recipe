json.array! @recipes do |recipe|
  json.id recipe.id
  json.name recipe.name
  json.title recipe.title
  json.text recipe.text
  json.image recipe.image
  json.user_id recipe.user_id
  json.user_sign_in current_user
end