class CreateLoans < ActiveRecord::Migration[6.1]
  def change
    create_table :loans, id: :string do |t|
      t.references :uniqname, type: :string, references: :users, null: false
      t.string :title
      t.string :author
      t.string :mms_id
      t.datetime :return_date
      t.datetime :checkout_date
      t.timestamps
    end
    rename_column :loans, :uniqname_id, :uniqname
    add_foreign_key :loans, :users, column: 'uniqname', primary_key: 'uniqname'
  end
end
