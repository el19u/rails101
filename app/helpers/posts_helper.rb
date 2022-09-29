module PostsHelper
 def delete_by(user, post)
    if post.user == current_user
      return "delete_by_user"
    end

    "delete_by_owner"
  end
end
