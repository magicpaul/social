class QuizResults < ActiveRecord::Migration
  def change
    create_table :quiz_results do |t|
      t.integer :user_id
      t.integer :quiz_id
      t.integer :score
    end
  end
end
