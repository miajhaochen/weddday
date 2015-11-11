class CreateGuestReplies < ActiveRecord::Migration
  def change
    create_table :guest_replies do |t|
      t.integer :attendee_form_id
      t.boolean :is_attend
      t.boolean :is_need_invitation
      t.integer :guest_group_id  #分類賓客EX: 女方國小同學
      t.integer :people_count
      t.integer :absent_type
      t.string :absent_reason
      t.string :zip_code
      t.string :city
      t.string :district
      t.string :address
      t.text :answer_json

      t.timestamps null: false
    end
  end
end
