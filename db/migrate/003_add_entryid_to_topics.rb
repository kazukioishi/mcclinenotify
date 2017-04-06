class AddEntryidToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :entry_id, :string
  end
end