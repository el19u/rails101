class AddGroupsTitleNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :groups, :title, false
  end
end
