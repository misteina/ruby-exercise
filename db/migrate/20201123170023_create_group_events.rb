class CreateGroupEvents < ActiveRecord::Migration[6.0]
    def change
        create_table :group_events do |t|
            t.string :name
            t.string :location
            t.text :description
            t.datetime :start
            t.datetime :end
            t.integer :duration  
            t.timestamps
        end
    end
end
