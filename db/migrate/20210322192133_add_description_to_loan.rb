class AddDescriptionToLoan < ActiveRecord::Migration[6.1]
  def change
    add_column :loans, :description, :string
  end
end
