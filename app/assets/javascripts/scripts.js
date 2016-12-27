function edit_answer() {
    event.preventDefault();

    var $editable_answer = $(this).closest('.js-answer'),
        $answer_textarea = $editable_answer.find('.js-existing-answer-content'),
        old_answer_value = $answer_textarea.val(),
        $editable_answer_cancel_button = $editable_answer.find('.js-existing-answer-cancel'),
        $editable_answer_form = $editable_answer.find('.js-existing-answer-edit-form'),
        $fields_for_attachments = $editable_answer.find('.js-question-attachment-field');

    $editable_answer.addClass('-editing');

    $editable_answer_form.off('ajax:success')
        .on('ajax:success', function (event, response) {
            generate_alert('Ваш ответ успешно изменён', 'success');

            var answer = response;

            $editable_answer.replaceWith(JST["templates/answer"](answer));

            $('.js-answer-edit-form-delete-attachment-link').off('ajax:success').on('ajax:success', remove_answer_attachment);

            $('.js-new-comment-trigger').on('click', function () {
                $(this).closest('.js-new-comment').addClass('-active');
            });

            $('.js-new-comment-form')
                .off('ajax:success').on('ajax:success', answer_comment_creation_handler)
                .off('ajax:error').on('ajax:error', function (event, response) {
                process_errors(event, response);
            });

            $fields_for_attachments.remove();

            $editable_answer.removeClass('-editing');
        })
        .on('ajax:error', function (event, response) {
            process_errors(event, response);
        });

    $editable_answer_cancel_button.off('click').on('click', function () {
        $editable_answer.removeClass('-editing');
        $answer_textarea.val(old_answer_value);
        $fields_for_attachments.remove();
    });
}

function edit_question() {
    event.preventDefault();

    var $question = $(this).closest('.js-question'),
        $question_content = $('.js-question-content'),
        $question_form = $question.find('.js-existing-question-edit-form'),
        $question_edit_cancel_button = $question.find('.js-question-edit-cancel'),
        $question_title_input = $question.find('.js-question-title-input'),
        $question_content_input = $question.find('.js-question-content-input'),
        old_question_title = $question_title_input.val(),
        old_question_content = $question_content_input.val(),
        $question_attachments_remove_links = $('.js-question-attachment-remove-link');

    $question.addClass('-editing');

    $question_form.off('ajax:success')
        .on('ajax:success', function (event, response) {
            generate_alert('Ваш вопрос успешно изменён', 'success');

            $question_form.replaceWith(response.question_form_html);
            $question_content.replaceWith(response.question_content_html);

            $('.js-question-edit-form-delete-attachment-link').off('ajax:success').on('ajax:success', remove_question_attachment);

            $question.removeClass('-editing');
        })
        .on('ajax:error', function (event, response, status, error) {
            process_errors(event, response);
        });

    $question_edit_cancel_button.off('click').on('click', function () {
        $question.removeClass('-editing');
        $question_title_input.val(old_question_title);
        $question_content_input.val(old_question_content);
    });

    $question_attachments_remove_links.off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                var $question_edit_form_attachment = $(this).closest('.js-question-edit-form-attachment'),
                    attachment_id = $question_edit_form_attachment.data('attachment-id');

                generate_alert(response.data, 'success');

                $question_edit_form_attachment.remove();
                $('.js-question-attachment[data-attachment-id="' + attachment_id + '"]').remove();

                break;
            case 'error':
                var errors_array = get_errors_array(response.data),
                    errors_list = errors_to_list(errors_array),
                    errors = generate_errors_box(errors_list);

                $('.js-sidebar').append(errors);
                break;
        }
    });
}

function remove_question_attachment(event, response) {
    event.stopPropagation();

    var $attachment = $(this).closest('.js-question-attachment'),
        attachment_id = $attachment.data('attachment-id');

    $attachment.remove();

    $('.js-question-attached-files').find('.js-question-attachment[data-attachment-id=' + attachment_id + ']').remove();
}

function remove_answer_attachment(event, response) {
    event.stopPropagation();

    var $attachment = $(this).closest('.js-answer-attachment'),
        attachment_id = $attachment.data('attachment-id');

    $attachment.remove();

    $('.js-answer-attachments-list').find('.js-answer-attachment[data-attachment-id=' + attachment_id + ']').remove();
}

function get_errors_array(obj) {
    var errors = [];

    for (var error_field in obj) {
        if (obj.hasOwnProperty(error_field)) {
            obj[error_field].forEach(function (error_message) {
                errors.push('[:' + error_field + '] ' + error_message);
            });
        }
    }

    return errors;
}

function errors_to_list(errors_array) {
    var errors_html = '<ul class="errors_list errors-list">';

    errors_array.forEach(function (error_message) {
        errors_html += '<li>' + error_message + '</li>';
    });

    errors_html += '</ul>';

    return errors_html;
}

function generate_errors_box(errors_list, resource, resource_id) {
    return '<div class="errors" data-' + resource + '-id="' + resource_id + '">' +
        '<h4 class="errors_header">Следующие ошибки помешали сохранению:</h4>' +
        errors_list +
        '</div>';
}

function process_errors(event, response) {
    var $event_target = $(event.target),
        resource = $event_target.data('resource'),
        resource_id = $event_target.data('resource_id'),
        errors_array = get_errors_array(JSON.parse(response.responseText).errors),
        errors_list = errors_to_list(errors_array),
        new_errors_block = generate_errors_box(errors_list, resource, resource_id),
        $previous_errors = $('.errors[data-' + resource + '-id="' + resource_id + '"]');

    $('.js-sidebar').append(new_errors_block);

    if ($previous_errors) {
        $previous_errors.remove();
    }
}

function generate_alert(message, type) {
    if (typeof type === 'undefined') {
        type = 'info';
    }

    var template = '<div class="alert alert-' + type + ' alert-dismissable">' +
        '<button type="button" class="close" ' +
        'data-dismiss="alert" aria-hidden="true">' +
        '&times;' +
        '</button>' +
        message +
        '</div>';

    $('.js-alerts-box').append(template);
}

function process_question_voting(event, response) {
    if (response.status === 'success') {
        $('.js-question-vote-count').text(response.rating);
        $('.js-question-downvote, .js-question-upvote, .js-question-unvote').toggleClass('-hidden');
    }
}

function process_answer_voting(event, response) {
    if (response.status === 'success') {
        var $answer = $(this).closest('.js-answer');
        $('.js-answer-vote-count', $answer).text(response.rating);
        $('.js-answer-downvote, .js-answer-upvote, .js-answer-unvote', $answer).toggleClass('-hidden');
    }
}

function answer_comment_creation_handler(event, response) {
    generate_alert('Ваш коммент сохранён', 'success');
    $(this).closest('.js-new-comment').removeClass('-active');
    this.reset();
}

function mark_as_best_action_handler(target) {
    var $new_marked_answer = $(target).closest('.answer');

    generate_alert('Ответ отмечен как лучший', 'success');

    $new_marked_answer.addClass('-best').siblings('.answer').removeClass('-best');

    $new_marked_answer.detach();

    $('.js-answers-index-table').prepend($new_marked_answer);
}

$(document).on('ready', function () {
    var $answers_table = $('.js-answers-index-table');

    $('.js-edit-question').on('click', edit_question);

    $answers_table
        .on('ajax:success', '.js-delete-answer', function (event, response) {
            var $deletable_answer = $(this).closest('.js-answer');
            $deletable_answer.remove();

            generate_alert('Ваш ответ удалён', 'success');
        })
        .on('ajax:error', function (event, response, status, error) {
            process_errors(event, response);
        });

    $answers_table.on('click', '.js-edit-answer', edit_answer);

    $('.js-new-answer-for-question-form')
        .on('ajax:success', function (event) {
            event.preventDefault();

            var $new_answer_for_question_form = $(this).closest('.js-new-answer-for-question-form'),
                $fields_for_attachments = $new_answer_for_question_form.find('.js-question-attachment-field'),
                $content_input = $('.js-new-answer-for-question-content-input');

            generate_alert('Ваш ответ сохранён', 'success');

            $fields_for_attachments.remove();

            $content_input.val('');

            $('.js-answer-edit-form-delete-attachment-link').off('ajax:success').on('ajax:success', remove_answer_attachment);
        })
        .on('ajax:error', function (event, response) {
            process_errors(event, response);
        });

    $answers_table
        .on('ajax:success', '.js-mark-answer-as-best', function (event, response) {
            mark_as_best_action_handler(this);
        })
        .on('ajax:error', function (event, response) {
            process_errors(event, response);
        });

    $('.js-question-edit-form-delete-attachment-link').off('ajax:success').on('ajax:success', remove_question_attachment);
    $('.js-answer-edit-form-delete-attachment-link').off('ajax:success').on('ajax:success', remove_answer_attachment);

    $('.js-question-downvote, .js-question-upvote, .js-question-unvote').on('ajax:success', process_question_voting);
    $('.js-answer-downvote, .js-answer-upvote, .js-answer-unvote').on('ajax:success', process_answer_voting);

    $('.js-new-comment-trigger').on('click', function () {
        $(this).closest('.js-new-comment').addClass('-active');
    });

    $('.js-new-comment-form')
        .on('ajax:success', answer_comment_creation_handler)
        .on('ajax:error', function (event, response) {
            process_errors(event, response);
        });

    var $question_subscription_control = $('.js-subscription-control');

    $question_subscription_control
        .on('ajax:success', '.js-subscription-add', function (event, response) {
            $question_subscription_control.html(JST["templates/subscription_remove_link"](response));
        })
        .on('ajax:success', '.js-subscription-delete', function () {
            $question_subscription_control.html(JST["templates/subscription_add_link"]());
        });
});
