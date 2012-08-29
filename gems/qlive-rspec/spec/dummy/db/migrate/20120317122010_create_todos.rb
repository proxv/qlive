class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :todo_list_id
      t.text :content
      t.timestamps
    end

    create_table :todo_lists do |t|
      t.string :name
      t.timestamps
    end
  end
end
