class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :size
      t.integer :stock
      t.string :brand
      t.references :category, foreign_key: true
      t.string :description

      t.timestamps
    end

  end
end
