class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 20
      t.string :password_digest, null: false
      t.string :first_name, null: false, limit: 30
      t.string :last_name, null: false, limit: 20
      t.string :email, null: false, limit: 345
      t.string :phone, limit: 20
      t.text :note, limit: 2000

      t.timestamps
    end

    
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
