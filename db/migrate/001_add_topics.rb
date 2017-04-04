class AddTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.datetime :creation_date
      t.string :recipient_id
      t.string :recipients
      t.text :subject
      t.text :content
      t.text :first_name
      t.text :last_name
      t.text :deadline_text
      t.integer :sender_grade
      t.timestamps
    end
  end
end