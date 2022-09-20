# frozen_string_literal: true
module GroupsHelper
  def render_group_description(group)
    simple_format(group.description)
  end
end
