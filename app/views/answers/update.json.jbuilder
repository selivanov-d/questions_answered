json.id @answer.id
json.user_id @answer.user_id
json.content @answer.content

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.filename attachment.file.identifier
  json.url attachment.file.url
end

json.comments @answer.comments do |comment|
  json.id comment.id
  json.content comment.content
end
