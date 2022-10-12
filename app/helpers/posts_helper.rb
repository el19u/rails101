# frozen_string_literal: true
module PostsHelper
  def read_authorization?(post)
    return true if post.author?(current_user)
    return true if post.group.owner?(current_user) && (post.block? || post.update_decline?)
    return true if post.publish?

    false
  end

  def post_status_message(status)
    status = status.to_sym

    status_messages = {
      publish: "發布中文章",
      delete_by_post_author: "文章已被使用者刪除",
      block: "文章已被管理員封鎖",
      update_verify: "文章更新中",
      update_decline: "版主拒絕更新文章",
      cancel_update_verify: "使用者取消審核"
    }

    status_messages[status]
  end
end
