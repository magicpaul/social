class AddNextQuizToQuizResults < ActiveRecord::Migration
  def self.up
    add_column :quiz_results, :next_quiz, :boolean, :default => false
  end

  def self.down
    remove_column :quiz_results, :next_quiz
  end
end
