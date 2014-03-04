class AddAttachmentAttachmentToStatuses < ActiveRecord::Migration
  def self.up
    change_table :statuses do |t|
      t.attachment :attachment
    end
  end

  def self.down
    drop_attached_file :statuses, :attachment
  end
end
