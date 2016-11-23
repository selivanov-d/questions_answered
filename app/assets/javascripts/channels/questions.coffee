App.questions = App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->

  received: (data) ->
    $('.js-questions-index-table').append(JST["templates/question"](data.question))
