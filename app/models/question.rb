class Question < ActiveRecord::Base
  # Attributes we want to manipulate need to be accessible
  attr_accessible :content, :survey_id, :answers_attributes, :attachment
  # Associations. Questions belongs to a quiz and can have many answers.
  belongs_to :quiz
  has_many :answers
  # Can nest attributes for answers.
  accepts_nested_attributes_for :answers, allow_destroy: true
  # Must have content
  validates :content, presence: true
  # Attachment stuff - so we can upload an image.
  has_attached_file :attachment,
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
end
