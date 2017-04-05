class AddColumnToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :send_ok, :boolean
  end
end