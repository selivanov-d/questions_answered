App.comments = App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->

  received: (data) ->
    $('.questions-index-table tbody').append(JST["templates/question"](data.question))
