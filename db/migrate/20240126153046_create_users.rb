class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 15
      t.string :email, null: false, limit: 319
      t.string :icon_url, null: false, limit: 255

      t.timestamps
    end
  end
end
