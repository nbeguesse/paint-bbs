Paperclip.interpolates :board_id do |attachment, style|
  attachment.instance.board.slug
end
Paperclip.interpolates :ext do |attachment, style|
  out = File.extname(attachment.original_filename)
  out.present? ? out : "png"
end