<<<<<<< HEAD
json.extract! user, :id, :email, :created_at, :updated_at
=======
json.extract! user, :id, :username, :password, :created_at, :updated_at
>>>>>>> b339cc41de4cde6b61b1164bb97564f691fb6cc8
json.url user_url(user, format: :json)
