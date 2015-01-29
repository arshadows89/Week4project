class CreateUsersTable < ActiveRecord::Migration
  def change
  	 create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
  		t.string :username
  		t.string :password
  		t.text :Bio
  		t.string :Interest1
  		t.string :Interest2
  		t.string :Interest3
  		t.string :location
  	end
  end
end
