class AddColumnsToLoans < ActiveRecord::Migration[6.1]
  def change
    add_column :loans, :barcode, :string
    add_column :loans, :call_number, :string
  end
end
