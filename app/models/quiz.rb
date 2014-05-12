class Quiz < ActiveRecord::Base
  # Quiz name and question attributes are accessible
  attr_accessible :name, :questions_attributes
  # Associations. A quiz has many questions and many quiz results
  has_many :questions
  has_many :quiz_results
  # Can take attributes for questions
  accepts_nested_attributes_for :questions, allow_destroy: true
  # Name is required
  validates :name, presence: :true
end
