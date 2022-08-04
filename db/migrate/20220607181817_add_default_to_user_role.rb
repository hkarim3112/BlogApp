# frozen_string_literal: true

# add default role to user migration
class AddDefaultToUserRole < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :role, from: nil, to: 0)
  end
end
