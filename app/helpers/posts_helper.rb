# frozen_string_literal: true
module PostsHelper
  def delete_by(user, post)
    post.user == current_user ? "delete_by_user" : "delete_by_owner"
  end

  def delete_post_at_author_list(status)
    status == "draft" ? "trash" : "delete_by_user"
  end

  def cancel_verify(status)
    status == "draft" ? "cancel_update_verify" : "draft"
  end

  def decline_status(status)
    status == "pendding" ? "decline" : "update_fail"
  end

  def author_post_lists(status)
    status_lists = ["decline", "draft", "update_fail", "cancel_update_verify"]

    status_lists.include?(status)
  end

  def read_authorization(post)
    return true if current_user_post?(post)

    status = post.status.to_sym
    read_authorization_status_lists = [:publish]
    read_authorization_status_lists.include?(status)
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

  def check_post_not_delted(status)
    status = status.to_sym
    status_lists = [:delete_by_user, :delete_by_owner, :block]

    !status_lists.include?(status)
  end

  def current_user_post?(post_user)
    post_user == current_user
  end

  def group_owner?(group)
    group.user == current_user
  end
end
