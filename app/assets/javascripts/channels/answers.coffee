App.comments = App.cable.subscriptions.create 'AnswersChannel',
  connected: ->

  received: (data) ->
    answer = $.parseJSON(data.answer)
    $('.js-answers-index-table').append(JST["templates/answer"](answer))
