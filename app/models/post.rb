# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  PUBLISH_STATUS = [
    :publish,
    :delete_by_user,
    :delete_by_owner,
    :block,
    :update_fail,
    :update_verify
  ].freeze

  CURRENT_USER_STATUS = [
    :pendding,
    :decline,
    :draft,
    :update_verify,
    :cancel_update_verify,
    :update_fail
  ].freeze

  OWNER_STATUS = [
    :pendding,
    :update_verify
  ].freeze

  enum status: {
    draft: 0,
    pendding: 1,
    publish: 2,
    decline: 3,
    delete_by_owner: 4,
    delete_by_user: 5,
    block: 6,
    update_fail: 7,
    update_verify: 8,
    cancel_update_verify: 9,
  }

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :pendding
    state :publish
    state :decline
    state :delete_by_owner
    state :delete_by_user
    state :block
    state :update_verify
    state :update_fail
    state :cancel_update_verify

    event :draft do
      transitions from: [:pendding, :update_verify], to: :draft
    end

    event :pendding do
      transitions from: [:draft, :update_fail, :decline], to: :pendding
    end

    event :publish do
      transitions from: [:pendding, :update_verify], to: :publish
    end

    event :decline do
      transitions from: [:pendding], to: :decline
    end

    event :delete_by_user do
      transitions from: [:publish, :update_verify], to: :delete_by_user
    end

    event :block do
      transitions from: [:publish, :update_fail, :update_verify], to: :block
    end

    event :update_verify do
      transitions from: [:publish], to: :update_verify
    end

    event :update_fail do
      transitions from: [:update_verify], to: :update_fail
    end
  end
end
