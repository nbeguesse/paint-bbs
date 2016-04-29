FactoryGirl.define do
  factory :post do
    title "My drawing"
    message "A belated happy birthday message"
    in_progress false
    board_id 1
    image_file_size 3666
    image_content_type "image/png"
    image_file_name "blob"
    image_updated_at "2016-04-27 04:26:51"
    anim_content_type "application/octet-stream"
    anim_file_name "blob"
    anim_updated_at "2016-04-27 04:26:51"
    anim_file_size 715
  end

end