class CreateIndicators < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_indicators do |t|
      t.string :apiotics_instance
      t.string :name
      t.timestamps
    end
  end
end