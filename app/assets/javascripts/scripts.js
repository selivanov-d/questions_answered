function create_new_answer(event, response) {
    event.preventDefault();

    var $new_answer_for_question_form = $(this).closest('.js-new-answer-for-question-form'),
        $fields_for_attachments = $new_answer_for_question_form.find('.js-question-attachment-field'),
        $table_with_answers = $('.js-answers-index-table'),
        $content_input = $('.js-new-answer-for-question-content-input');

    switch (response.status) {
        case 'success':
            generate_alert(response.data.message, 'success');

            $table_with_answers.append(response.data.html);

            $fields_for_attachments.remove();

            $content_input.val('');

            break;
        case 'error':
            var errors_array = get_errors_array(response.data),
                errors_list = errors_to_list(errors_array),
                errors = generate_errors_box(errors_list);

            $('.js-sidebar').append(errors);
            break;
    }
}

function edit_answer() {
    event.preventDefault();

    var $editable_answer = $(this).closest('.js-answer'),
        $answer_textarea = $editable_answer.find('.js-existing-answer-content'),
        old_answer_value = $answer_textarea.val(),
        $editable_answer_cancel_button = $editable_answer.find('.js-existing-answer-cancel'),
        $editable_answer_form = $editable_answer.find('.js-existing-answer-edit-form'),
        $fields_for_attachments = $editable_answer.find('.js-question-attachment-field');

    $editable_answer.addClass('-editing');

    $editable_answer_form.off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                generate_alert(response.data.message, 'success');

                $editable_answer.replaceWith(response.data.html);

                $fields_for_attachments.remove();

                $editable_answer.removeClass('-editing');

                break;
            case 'error':
                var errors_array = get_errors_array(response.data),
                    errors_list = errors_to_list(errors_array),
                    errors = generate_errors_box(errors_list);

                $('.js-sidebar').append(errors);
                break;
        }
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
        $question_title = $question.find('.js-question-title'),
        $question_content = $question.find('.js-question-content'),
        $question_edit_cancel_button = $question.find('.js-question-edit-cancel'),
        $question_title_input = $question.find('.js-question-title-input'),
        $question_content_input = $question.find('.js-question-content-input'),
        old_question_title = $question_title_input.val(),
        old_question_content = $question_content_input.val(),
        $question_attachments_remove_links = $('.js-question-attachment-remove-link');

    $question.addClass('-editing');

    $question_form.off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                generate_alert(response.data.message, 'success');

                var question_form_html = response.data.question_form_html,
                    question_content_html = response.data.question_content_html;

                $question_form.replaceWith(question_form_html);
                $question_content.replaceWith(question_content_html);

                $question.removeClass('-editing');

                break;
            case 'error':
                var errors_array = get_errors_array(response.data),
                    errors_list = errors_to_list(errors_array),
                    errors = generate_errors_box(errors_list);

                $('.js-sidebar').append(errors);
                break;
        }
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

function generate_errors_box(errors_list) {
    return '<div class="errors">' +
        '<h4 class="errors_header">Следующие ошибки помешали сохранению:</h4>' +
        errors_list +
        '</div>';
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

$(document).on('ready', function () {
    var $answers_table = $('.js-answers-index-table');

    $('.js-edit-question').on('click', edit_question);

    $answers_table.on('ajax:success', '.js-delete-answer', function (event, response) {
        switch (response.status) {
            case 'success':
                var $deletable_answer = $(this).closest('.js-answer');
                $deletable_answer.remove();

                generate_alert(response.data.message, 'success');

                break;
            case 'error':
                var errors_array = get_errors_array(response.data),
                    errors_list = errors_to_list(errors_array),
                    errors = generate_errors_box(errors_list);

                $('.js-sidebar').append(errors);
                break;
        }
    });

    $answers_table.on('click', '.js-edit-answer', edit_answer);

    $('.js-new-answer-for-question-form').on('ajax:success', create_new_answer);

    $answers_table.on('ajax:success', '.js-mark-answer-as-best', function (event, response) {
        switch (response.status) {
            case 'success':
                var $new_marked_answer = $(this).closest('.answer');

                generate_alert(response.data, 'success');

                $new_marked_answer.addClass('-best').siblings('.answer').removeClass('-best');

                $new_marked_answer.detach();

                $('.js-answers-index-table').prepend($new_marked_answer);

                break;
            case 'error':
                var errors_array = get_errors_array(response.data),
                    errors_list = errors_to_list(errors_array),
                    errors = generate_errors_box(errors_list);

                $('.js-sidebar').append(errors);
                break;
        }
    });

    $('.js-question-edit-form-delete-attachment-link').on('ajax:success', function (event, response) {
        event.stopPropagation();

        var $attachment = $(this).closest('.js-question-attachment'),
            attachment_id = $attachment.data('attachment-id');

        $attachment.remove();

        $('.js-question-attached-files').find('.js-question-attachment[data-attachment-id=' + attachment_id +']').remove();
    });
});
