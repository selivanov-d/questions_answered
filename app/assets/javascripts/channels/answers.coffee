App.comments = App.cable.subscriptions.create {
  channel: "AnswersChannel",
  question_id: gon.question_id
},
  connected: ->

  received: (data) ->
    answer = $.parseJSON(data.answer)
    $('.js-answers-index-table').append(JST["templates/answer"](answer))
