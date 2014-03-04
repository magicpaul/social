class AddAttachmentBannerToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :banner
    end
  end

  def self.down
    drop_attached_file :users, :banner
  end
end
