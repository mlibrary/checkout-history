class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users, primary_key: 'uniqname', id: :string) do |t|
      t.boolean :retain_history, default: false
      t.boolean :confirmed, default: false
      t.timestamps
    end
  end
end
