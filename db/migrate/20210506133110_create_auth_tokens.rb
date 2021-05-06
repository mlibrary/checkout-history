class CreateAuthTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :auth_tokens do |t|
      t.string :token, :unique => true
      t.string :name, :unique => true

      t.timestamps
    end
  end
end
