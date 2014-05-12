class QuizResult < ActiveRecord::Base
    # Assocations. A quiz result belongs to a user and a quiz
    belongs_to :user
    belongs_to :quiz
    # We need to access the data to manipulate it.
    attr_accessible :user_id, :quiz_id, :score, :next_quiz
end