# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :content, presence: true

  acts_as_votable # association for like gem "act_as_votable"
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  def reported?(user_id)
    find_report(user_id).exists?
  end

  def find_report(user_id)
    reports.where(user_id: user_id)
  end
end
