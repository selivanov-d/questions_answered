App.comments = App.cable.subscriptions.create {
  channel: 'CommentsChannel',
  question_id: gon.question_id
},
  connected: ->

  received: (data) ->
    comment = $.parseJSON(data.comment)

    switch comment.subject
      when 'Question'
        $selector = $('.js-comments-for-question-list[data-question-id="' + comment.subject_id + '"]')
      when 'Answer'
        $selector = $('.js-comments-for-answer-list[data-answer-id="' + comment.subject_id + '"]')

    $selector.append(JST["templates/comment"](comment))

