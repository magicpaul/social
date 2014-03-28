class CreateAnswersTable < ActiveRecord::Migration
    create_table "answers", :force => true do |t|
      t.string   "text"
      t.boolean  "correct"
      t.integer  "question_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
end
