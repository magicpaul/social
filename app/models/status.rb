class Status < ActiveRecord::Base
  attr_accessible :content, :user_id, :attachment, :remove_attachment
  belongs_to :user
  has_attached_file :attachment
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  attr_accessor :remove_attachment
  validates :content, presence: true,
  					  length: { minimum: 2 }
  validates :user_id, presence: true
  acts_as_votable
  before_save :perform_attachment_removal

  def perform_attachment_removal
  	if remove_attachment == '1' && !attachment.dirty?
  		self.attachment = nil
  	end
  end

end