# frozen_string_literal: true

# Posts migration
class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :status
      t.belongs_to :user

      t.timestamps
    end
  end
end
