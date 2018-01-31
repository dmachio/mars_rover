class CreateRoverFleets < ActiveRecord::Migration
  def change
    create_table :rover_fleets do |t|
      t.text :input
      t.text :output

      t.timestamps null: false
    end
  end
end
