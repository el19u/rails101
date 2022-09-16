class Post < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order("created_at DESC") }

  def is_member_of?(group)
    participated_groups.include?(group)
  end
end