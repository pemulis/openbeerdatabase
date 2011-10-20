class AddAdministratorToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :administrator, default: false, null: false
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :administrator
    end
  end
end
