class Question < ActiveRecord::Base
  attr_accessible :content, :survey_id, :answers_attributes, :attachment

  belongs_to :quiz
  has_many :answers
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :content, presence: true

  has_attached_file :attachment,
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/


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
