class CreateQuestionsTable < ActiveRecord::Migration
    create_table "questions", :force => true do |t|
      t.string   "text"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
end
