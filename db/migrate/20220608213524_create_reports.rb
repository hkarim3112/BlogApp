# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.integer :type, null: false, default: 0
      t.belongs_to :user, foreign_key: true
      t.references :reportable, polymorphic: true
      t.timestamps
    end
  end
end
