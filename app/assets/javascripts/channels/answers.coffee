App.answers = App.cable.subscriptions.create {
  channel: "AnswersChannel",
  question_id: gon.question_id
},
  connected: ->

  received: (data) ->
    answer = $.parseJSON(data.answer)
    $('.js-answers-index-table').append JST['templates/answer'](answer)

    $inserted_answer = $('.js-answers-index-table .js-answer:last')

    $('.js-answer-downvote, .js-answer-upvote, .js-answer-unvote', $inserted_answer).on 'ajax:success', process_answer_voting

    $('.js-new-comment-trigger', $inserted_answer).on 'click', ->
      $(this).closest('.js-new-comment').addClass '-active'

    $('.js-new-comment-form', $inserted_answer).off('ajax:success').on 'ajax:success', answer_comment_creation_handler

