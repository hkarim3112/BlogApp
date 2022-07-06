# frozen_string_literal: true

class AddTotalLikesToComment < ActiveRecord::Migration[5.2]
  def change
    change_table :comments do |t|
      t.integer :cached_votes_up, default: 0
    end
  end
end
