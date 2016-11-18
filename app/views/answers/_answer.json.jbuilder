json.content answer.content

json.attachments answer.attachments do |attachment|
  json.filename attachment.file.identifier
  json.url attachment.file.url
end
