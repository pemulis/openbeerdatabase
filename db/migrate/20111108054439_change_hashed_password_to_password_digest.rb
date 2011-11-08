class ChangeHashedPasswordToPasswordDigest < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :password_digest
    end

    User.connection.execute "UPDATE users SET password_digest = hashed_password"

    change_table :users do |t|
      t.remove :hashed_password
      t.change :password_digest, :string, limit: 128, null: false
    end
  end

  def down
    change_table :users do |t|
      t.string :hashed_password
    end

    User.connection.execute "UPDATE users SET hashed_password = password_digest"

    change_table :users do |t|
      t.remove :password_digest
      t.change :hashed_password, :string, limit: 128, null: false
    end
  end
end
