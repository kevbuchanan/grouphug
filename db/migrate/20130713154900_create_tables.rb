class CreateTables < ActiveRecord::Migration
  def change
    create_table :confessions do |t|
      t.string :text
      t.string :signature
      t.references :user
    end

    create_table :users do |t|
      t.string :name
      t.integer :grouphug_id
      t.string :type
    end
  end
end