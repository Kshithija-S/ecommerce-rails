class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.string :status, null: false
      t.float :total_price

      t.timestamps
    end
  end
end
