class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :profile_name, :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "96x96" }, :default_url => "avatar_:style.png"
  validates_attachment_content_type :avatar, :content_type => { :content_type => ["image/jpg", "image/gif", "image/png"] }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :profile_name, presence: true,
                           uniqueness: true,
                           format: {
                            with: /^[a-zA-Z0-9_-]+$/,
                            message: 'Must be formatted correctly'
                           }

  has_many :statuses
  has_many :user_friendships
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
end
