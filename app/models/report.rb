# frozen_string_literal: true

class Report < ApplicationRecord
  enum report_type: {
    irrelevant: 0,
    abuse: 1,
    spam: 2
  }

  validates :report_type, inclusion: { in: report_types.keys }

  belongs_to :user
  belongs_to :reportable, polymorphic: true
end
