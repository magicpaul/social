class Status < ActiveRecord::Base
  attr_accessible :content, :user_id, :attachment, :remove_attachment
  belongs_to :user
  validates :content, presence: true,
  					  length: { minimum: 2 }
  validates :user_id, presence: true
  acts_as_votable

end