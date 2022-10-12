# frozen_string_literal: true
class Post < ApplicationRecord
  include AASM

  belongs_to :group
  belongs_to :user

  validates :content, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  PUBLISH_STATUS = [
    :publish,
    :delete_by_post_author,
    :block,
    :update_decline,
    :update_verify,
    :cancel_update_verify
  ].freeze

  AUTHOR_MAY_VERIFY_STATUS = [
    :draft,
    :verify,
    :decline,
    :update_decline,
    :update_verify,
    :cancel_update_verify
  ].freeze

  GROUP_OWNER_VERIFYABLE_STATUS = [
    :verify,
    :update_verify
  ].freeze

  enum status: {
    draft: 0,
    verify: 1,
    publish: 2,
    decline: 3,
    delete_by_post_author: 5,
    block: 6,
    update_decline: 7,
    update_verify: 8,
    cancel_update_verify: 9,
  }

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :verify
    state :publish
    state :decline
    state :delete_by_post_author
    state :block
    state :update_verify
    state :update_decline
    state :cancel_update_verify

    event :draft do
      transitions from: :verify, to: :draft
    end

    event :verify do
      transitions from: [:draft, :decline], to: :verify
    end

    event :publish do
      transitions from: [:verify, :update_verify], to: :publish
    end

    event :decline do
      transitions from: :verify, to: :decline
    end

    event :delete_by_post_author do
      transitions from: [:publish, :update_verify, :update_decline, :cancel_update_verify], to: :delete_by_post_author
    end

    event :block do
      transitions from: [:publish, :cancel_update_verify], to: :block
    end

    event :update_verify do
      transitions from: [:publish, :update_verify, :update_decline, :cancel_update_verify], to: :update_verify
    end

    event :update_decline do
      transitions from: :update_verify, to: :update_decline
    end

    event :cancel_update_verify do
      transitions from: :update_verify, to: :cancel_update_verify
    end
  end

  def author?(the_user)
    the_user == user
  end

  def viewable?
    publish? || cancel_update_verify? || delete_by_post_author?
  end

  def published?
    status.to_sym.in?(PUBLISH_STATUS)
  end

  def editable?
    publish? || cancel_update_verify?
  end
end
