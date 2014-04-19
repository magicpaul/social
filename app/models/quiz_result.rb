class QuizResult < ActiveRecord::Base
    belongs_to :user
    belongs_to :quiz

    attr_accessible :user_id, :quiz_id, :score
end