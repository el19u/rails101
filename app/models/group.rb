class Group < ApplicationRecord
  belongs_to :user
  has_many :posts
  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user

  validates :title, presence: true

  scope :recent, -> { order("created_at DESC") }
end