# frozen_string_literal: true

# add foreignkey to post migration
class Addforeignkeytopost < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :posts, :users
  end
end
