# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  PUBLISH_STATUS = [
    :publish,
    :delete_by_owner,
    :delete_by_user,
    :block,
    :update_fail,
    :update_verify,
    :cancel_update_verify
  ].freeze

  AUTHOR_MAY_VERIFY_STATUS = [
    :draft,
    :pendding,
    :decline,
    :update_fail,
    :update_verify,
    :cancel_update_verify
  ].freeze

  GROUP_OWNER_VERIFYABLE_STATUS = [
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
      transitions from: [:pendding, :delete_by_user], to: :decline
    end

    event :delete_by_user do
      transitions from: [:publish, :update_verify, :decline, :cancel_update_verify], to: :delete_by_user
    end

    event :block do
      transitions from: [:publish, :update_fail, :update_verify], to: :block
    end

    event :update_verify do
      transitions from: [:publish], to: :update_verify
    end

    event :update_fail do
      transitions from: [:pendding, :draft, :update_verify], to: :update_fail
    end

    event :cancel_update_verify do
      transitions from: [:update_verify], to: :cancel_update_verify
    end

    event :update_verify do
      transitions from: [:cancel_update_verify], to: :update_verify
    end

    event :block do
      transitions from: [:cancel_update_verify, :publish], to: :block
    end
  end

  def author_posts?
    decline? || draft? || update_fail? || cancel_update_verify?
  end

  def viewable?
    publish? || cancel_update_verify? || delete_by_user?
  end

  def published?
    update_verify?
  end

  def editable?
    publish? || cancel_update_verify?
  end
end
