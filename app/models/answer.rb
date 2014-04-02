class Answer < ActiveRecord::Base
  attr_accessible :content, :question_id, :correct
  belongs_to :question
  validates :content, presence: true
end
