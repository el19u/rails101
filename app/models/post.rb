# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order("created_at DESC") }

  enum status: {
    pendding: 0,
    published: 1,
    decline: 2,
    delete_by_owner: 3,
    delete_by_user: 4
  }

  aasm column: :status, enum: true do
    state :pendding, initial: true
    state :published
    state :decline
    state :delete_by_owner
    state :delete_by_user

    event :publish do
      transitions from: [:pendding, :decline], to: :published
    end

    event :delete_by_owner do
      transitions from: [:pendding, :published, :decline], to: :delete_by_owner
    end

    event :delete_by_user do
      transitions from: [:pendding, :published, :decline], to: :delete_by_user
    end
  end
end
