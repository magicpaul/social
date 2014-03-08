class CreateFavoriteStatuses < ActiveRecord::Migration
  def change
    create_table :favorite_statuses do |t|
      t.integer :status_id
      t.integer :user_id

      t.timestamps
    end
  end
end
