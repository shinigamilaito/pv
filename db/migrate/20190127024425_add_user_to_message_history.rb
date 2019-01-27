class AddUserToMessageHistory < ActiveRecord::Migration[5.1]
  def change
    add_reference :message_histories, :user, foreign_key: true
  end
end
