class CreateIndicatorLeds < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_leds do |t|
      
      t.boolean :led_state
      t.boolean :led_state_ack
      t.boolean :led_state_complete
      
      
      t.integer :indicator_id
      t.timestamps
    end
  end
end