# frozen_string_literal: true

class AddSuggestionToComments < ActiveRecord::Migration[5.2]
  def change
    change_table :comments do |t|
      t.boolean :suggestion, default: false
    end
  end
end
