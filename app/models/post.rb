# frozen_string_literal: true

class Post < ApplicationRecord
  validates :content, :title, presence: true
  validates :title, length: { maximum: 100 }

  enum status: {
    pending: 0,
    published: 1
  }

  acts_as_votable # association for like gem "act_as_votable"
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  def reported?(user_id)
    find_report(user_id).exists?
  end

  def find_report(user_id)
    reports.where(user_id: user_id)
  end
end
