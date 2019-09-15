class CreateUsers < ActiveRecord::Migration[5.1]
  def up
     create_table :users do |t|
       t.string :username
       t.string :password_digest
#password_digest is required for BCrypt to work. BUT the attribute still
#equals password when using password in views and controller
     end
   end

   def down
     drop_table :users
   end
end
