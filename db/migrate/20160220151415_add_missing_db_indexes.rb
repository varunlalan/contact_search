class AddMissingDbIndexes < ActiveRecord::Migration
  def up
    db = ActiveRecord::Base.connection
    db.execute %(CREATE EXTENSION IF NOT EXISTS pg_trgm)

    add_index :contacts, :first_name
    add_index :contacts, :last_name
    add_index :contacts, :phone_number
  end
end
