class ChangeFromSingleTokenToPublicAndPrivateTokens < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.remove :token

      t.string :public_token,  :null => false, :limit => 64
      t.string :private_token, :null => false, :limit => 64

      t.index :private_token, :unique => true
      t.index [:public_token, :private_token], :unique => true
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :public_token
      t.remove :private_token

      t.string :token, :null => false, :limit => 64

      t.index :token, :unique => true
    end
  end
end
