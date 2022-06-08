# frozen_string_literal: true

# add default role to user migration
class AddDefaultToUserRole < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :role, :integer, default: 0
  end
end
