class RenameStartEndColumns < ActiveRecord::Migration[6.0]
    def change
        rename_column :group_events, :start, :eventstart
        rename_column :group_events, :end, :eventend
    end
end
