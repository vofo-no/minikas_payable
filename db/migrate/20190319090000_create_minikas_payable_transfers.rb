class CreateMinikasPayableTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :minikas_payable_transfers do |t|
      t.belongs_to :minikas_payable_batch, foreign_key: true
      t.belongs_to :payable, polymorphic: true
      t.integer :amount,               null: false, default: 0
      t.string :message,               null: false
      t.string :bank_account,          null: false
      t.string :recipient_name,        null: false
      t.string :recipient_postal_code, null: false
      t.string :recipient_postal_city, null: false

      t.timestamps
    end

    add_index :minikas_payable_transfers, :amount
    add_index :minikas_payable_transfers, :bank_account
  end
end
