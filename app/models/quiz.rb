class Quiz < ActiveRecord::Base
  attr_accessible :name, :questions_attributes
  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true
  validates :name, presence: :true
end