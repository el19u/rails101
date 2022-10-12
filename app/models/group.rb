# frozen_string_literal: true
class Group < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :delete_all
  has_many :group_relationships, dependent: :delete_all
  has_many :members, through: :group_relationships, source: :user

  validates :title, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  def owner?(the_user)
    the_user == user
  end
end
