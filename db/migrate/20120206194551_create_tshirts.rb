class CreateTshirts < ActiveRecord::Migration
  def change
    create_table :tshirts do |t|
      t.string :caption
      t.string :clipart
      t.integer :match
      t.string :no_match
      t.string :skipped
      t.timestamps
    end
  end
end
