class CreateIndicatorButtons < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_buttons do |t|
      
      t.boolean :safe
      t.boolean :safe_ack
      t.boolean :safe_complete
      
      
      t.integer :indicator_id
      t.timestamps
    end
  end
end