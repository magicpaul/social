class Activity < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :targetable, polymorphic: true
  acts_as_readable :on => :created_at

  def self.for_user(user, options={})
    friend_ids = user.friends.map(&:id).push(user.id)
    collection = where("user_id in (?)", friend_ids).order("created_at desc")
    if options[:since] && !options[:since].blank?
      since = DateTime.strptime( options[:since], '%s' )
      collection = collection.where("created_at > ?", since) if since
    end
    collection
  end
  def user_name
    user.full_name
  end
  def profile_name
    user.profile_name
  end
  def avatar
    user.avatar.url(:thumb)
  end
  def mark_read(user)
    self.mark_as_read! :for => user
  end
  def mark_all_read(user)
    self.mark_as_read! :all, :for => user
  end
  def as_json(options={})
    super(
        only: [:action, :id, :targetable, :targetable_type, :created_at, :targetable_id],
        include: :targetable,
        methods: [:user_name, :profile_name, :avatar]
    ).merge(options)
  end
end
