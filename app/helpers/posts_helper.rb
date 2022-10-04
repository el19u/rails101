# frozen_string_literal: true
module PostsHelper
  def delete_by(user, post)
    post.user == current_user ? "delete_by_user" : "delete_by_owner"
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
      published: "發布中文章",
      delete_by_user: "文章已被使用者刪除",
      delete_by_owner: "文章已被群組管理員刪除",
      block: "文章已被管理員封鎖",
      update_verify: "文章更新中",
      update_fail: "版主拒絕更新文章"
    }

    status_messages[status]
  end
end
