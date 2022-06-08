# frozen_string_literal: true

class Report < ApplicationRecord
  enum type: {
    irrelevant: 0,
    abuse: 1,
    spam: 2
  }

  belongs_to :user
  belongs_to :reportable, polymorphic: true
end
