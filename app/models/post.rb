class Post < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :content, presence: true

  scope :recent, -> { order("created_at DESC") }
end
