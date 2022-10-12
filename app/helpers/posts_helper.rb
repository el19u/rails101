# frozen_string_literal: true
module PostsHelper
  def delete_by(post_user)
    current_user_post?(post_user) ? "delete_by_user" : "delete_by_owner"
  end

  def read_authorization(post)
    current_user_post?(post) || post.viewable?
  end

  def post_status_message(status)
    status = status.to_sym

    status_messages = {
      publish: "發布中文章",
      delete_by_user: "文章已被使用者刪除",
      delete_by_owner: "文章已被群組管理員刪除",
      block: "文章已被管理員封鎖",
      update_verify: "文章更新中",
      update_fail: "版主拒絕更新文章",
      cancel_update_verify: "使用者取消審核"
    }

    status_messages[status]
  end

  def current_user_post?(post_user)
    post_user == current_user
  end

  def group_owner?(group)
    group.user == current_user
  end
end
