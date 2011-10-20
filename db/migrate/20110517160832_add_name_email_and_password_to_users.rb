class AddNameEmailAndPasswordToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :name,            null: false, limit: 64
      t.string :email,           null: false, limit: 255
      t.string :hashed_password, null: false, limit: 128
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :name
      t.remove :email
      t.remove :hashed_password
    end
  end
end
