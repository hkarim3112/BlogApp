# frozen_string_literal: true

class Comment < ApplicationRecord
  validates :content, presence: true

  acts_as_votable # association for like gem "act_as_votable"
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
end
