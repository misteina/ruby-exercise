class PlaceStatusAfterDuration < ActiveRecord::Migration[6.0]
    def change

        add_column :group_events, :tmp_status, :string, after: :duration
        remove_column :group_events, :status
        rename_column :group_events, :tmp_status, :status
        
    end
end
