class CreateMinikasPayableBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :minikas_payable_batches do |t|
      t.belongs_to :owner, polymorphic: true
      t.integer :number, null: false, default: 0
      t.boolean :closed, null: false, default: false
      t.date :date

      t.timestamps
    end
  end
end
