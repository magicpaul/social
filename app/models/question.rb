class Question < ActiveRecord::Base
  attr_accessible :content, :survey_id, :answers_attributes
  belongs_to :quiz
  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :content, presence: true

  def useranswer
     incorrect
     answers.select {|c| c.correct}[0]
  end

  def incorrect
     answers.each {|c| c.correct = false}
  end

  def useranswer= answer
     if !answer.nil?
        answer.correct = false
     end

     if answers.include? answer
        answer.correct = true
     else
        answers << answer
        answer.correct = true
     end
  end

end
