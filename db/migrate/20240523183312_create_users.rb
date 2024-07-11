class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, limit: 20, null: false
      t.string :password_digest, null: false
      t.string :first_name, limit: 30, null: false
      t.string :last_name, limit: 20, null: false
      t.string :email, limit: 345, null: false
      t.string :phone, limit: 20
      t.text :note, limit: 2000
      t.boolean :admin, default: false, null: false
      t.boolean :approved, default: false, null: false

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true

    execute <<-SQL
      CREATE OR REPLACE FUNCTION notify_approval_update() RETURNS trigger AS $$
      BEGIN
        PERFORM pg_notify('approval_update', NEW.id::text);
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE TRIGGER approval_update_trigger
      AFTER UPDATE OF approved ON users
      FOR EACH ROW
      WHEN (OLD.approved IS DISTINCT FROM NEW.approved)
      EXECUTE FUNCTION notify_approval_update();
    SQL
    
  end
end