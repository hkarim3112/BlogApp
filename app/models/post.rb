# frozen_string_literal: true

class Post < ApplicationRecord
  validates :content, :title, presence: true
  acts_as_votable

  enum status: {
    pending: 0,
    published: 1
  }

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
  # has_many_attached :image, dependent: :purge

  def reported?(user_id)
    get_report(user_id).exists?
  end

  def get_report(user_id)
    reports.where(user_id: user_id)
  end
end
