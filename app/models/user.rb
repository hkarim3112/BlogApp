# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable

  enum role: {
    normal: 0,
    moderator: 1,
    admin: 2
  }

  acts_as_voter # association for like gem "act_as_votable"
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
end
