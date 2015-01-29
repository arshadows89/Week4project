class CreatePostsTable < ActiveRecord::Migration
  def change
  	  create_table :posts do |t|
  		t.string :title
  		t.text :content
  		t.timestamp null: false
  	end
  end
end
