module PostsHelper
 def delete_by(user, post)
    if post.user == current_user
      return "delete_by_user"
    end

    "delete_by_owner"
  end

  def post_status_message(post)
    post = post.to_sym

    status_messages = {
      delete_by_user: "文章已被使用者刪除",
      delete_by_owner: "文章已被群組管理員刪除",
      block: "文章已被管理員封鎖",
      update_post: "版主審核更新文章",
    }

    status_messages[post]
  end
end
