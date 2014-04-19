class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name, :avatar, :banner, :admin
  has_attached_file :avatar,
                    :styles => { :medium => "300x300#", :thumb => "96x96#" },
                    :default_url => "avatar_:style.png",
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_attached_file :banner,
                    :styles => { :normal => "595x200#" },
                    :default_url => "/assets/banner_:style.jpg",
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :profile_name, presence: true,
                           uniqueness: true,
                           format: {
                            with: /^[a-zA-Z0-9_-]+$/,
                            message: 'Must be formatted correctly'
                           }
  acts_as_voter
  acts_as_reader
  has_many :activities
  has_many :statuses
  has_many :trophies
  has_many :user_friendships
  has_many :quiz_results
  has_many :friends, through: :user_friendships,
                     conditions: {user_friendships: {state: 'accepted'}}
  has_many :pending_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: {state: 'pending'}
  has_many :pending_friends, through: :pending_user_friendships, source: :friend
  has_many :requested_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: {state: 'requested'}
  has_many :requested_friends, through: :requested_user_friendships, source: :friend
  has_many :blocked_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: {state: 'blocked'}
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
  has_many :accepted_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: {state: 'accepted'}
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend
  def full_name
  	return first_name + " " + last_name
  end

  def to_param
    profile_name
  end

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)
    "http://gravatar.com/avatar/#{hash}?d=identicon&s=96"
  end
  def gravatar_url_small
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)
    "http://gravatar.com/avatar/#{hash}?d=identicon&s=20"
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end
  def is_friends?(other_user)
    accepted_friends.include?(other_user)
  end
  def is_self?(other_user)
    true
  end
  def has_unread?(activity)
    activity.unread?(self)
  end
  def create_activity(item, action)
    activity = activities.new
    activity.targetable = item
    activity.action = action
    activity.save
    activity
  end
end
