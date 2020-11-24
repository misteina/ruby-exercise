class AddStatusToGroupEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :group_events, :status, :string
  end
end
