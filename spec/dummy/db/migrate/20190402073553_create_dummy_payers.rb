class CreateDummyPayers < ActiveRecord::Migration[5.2]
  def change
    create_table :dummy_payers do |t|
      t.integer :amount
      t.string :message
      t.string :bank_account
      t.string :recipient_name
      t.string :recipient_postal_code
      t.string :recipient_postal_city
      t.integer :learning_association_id

      t.timestamps
    end
  end
end
