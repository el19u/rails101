# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  enum status: {
    draft:0,
    pendding: 1,
    published: 2,
    decline: 3,
    delete_by_owner: 4,
    delete_by_user: 5,
    block: 6,
    update_fail: 7,
    update_verify: 8
  }

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :pendding
    state :published
    state :decline
    state :delete_by_owner
    state :delete_by_user
    state :block
    state :update_verify
    state :update_fail

    event :publish do
      transitions from: [:pendding, :decline], to: :published
    end

    event :delete_by_owner do
      transitions from: [:pendding, :published, :decline, :draft], to: :delete_by_owner
    end

    event :delete_by_user do
      transitions from: [:pendding, :published, :decline, :draft], to: :delete_by_user
    end
  end
end
