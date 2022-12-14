# frozen_string_literal: true
module UsersHelper
  def is_active_user?(current_user)
    if current_user.blank?
      content_tag(:li, link_to("登入", new_user_session_path)) <<
      content_tag(:li, link_to("註冊", new_user_registration_path))
    else
      content_tag(:li, class: "dropdown") do
        content_tag(:button, "Hi! #{current_user.email}", class: "btn btn-secondary dropdown-toggle", data: {bs_toggle: "dropdown"}) <<
        content_tag(:ul, class: "dropdown-menu") do
          content_tag(:li, link_to("我的群組", account_groups_path)) <<
          content_tag(:li, link_to("我的文章", account_posts_path)) <<
          content_tag(:li, link_to("登出", destroy_user_session_path, method: :delete))
        end
      end
    end
  end
end
