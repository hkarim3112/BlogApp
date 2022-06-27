# frozen_string_literal: true

class AddTotalLikesToPost < ActiveRecord::Migration[5.2]
  def change
    change_table :posts do |t|
      t.integer :cached_votes_up, default: 0
    end
  end
end
