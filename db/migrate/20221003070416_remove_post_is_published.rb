class RemovePostIsPublished < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :is_published
  end
end
