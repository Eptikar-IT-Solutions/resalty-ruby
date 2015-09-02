class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :messageId
      t.string :number
      t.text :msg
      t.integer :status_number
    end
  end
end
