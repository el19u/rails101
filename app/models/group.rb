class Group < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :delete_all
  has_many :group_relationships, dependent: :delete_all
  has_many :members, through: :group_relationships, source: :user

  validates :title, presence: true

  scope :recent, -> { order("created_at DESC") }
end