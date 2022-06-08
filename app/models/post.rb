# frozen_string_literal: true

class Post < ApplicationRecord
  enum status: {
    pending: 0,
    published: 1
  }

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy
end
