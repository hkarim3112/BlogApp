# frozen_string_literal: true

# Posts migration
class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :status
      t.belongs_to :user

      t.timestamps
    end
  end
end
