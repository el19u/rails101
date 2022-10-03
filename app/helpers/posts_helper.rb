# frozen_string_literal: true
module PostsHelper
  def delete_by(user, post)
    if post.user == current_user
      return "delete_by_user"
    end

     "delete_by_owner"
  end

  def update_success_fail(status)
    if status == "pendding"
      return "declined"
    else
      return "update_fail"
    end
  end

  def post_status_message(status)
    status = status.to_sym

    status_messages = {
      delete_by_user: "文章已被使用者刪除",
      delete_by_owner: "文章已被群組管理員刪除",
      block: "文章已被管理員封鎖",
      update_post: "版主審核更新文章",
      update_fail: "版主拒絕更新文章"
    }

    status_messages[status]
  end
end
