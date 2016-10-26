function edit_answer() {
    event.preventDefault();

    var $editable_answer = $(this).closest('.answer'),
        $answer_textarea = $editable_answer.find('.js-existing-answer-content'),
        old_answer_value = $answer_textarea.val(),
        $editable_answer_cancel_button = $editable_answer.find('.js-existing-answer-cancel'),
        $editable_answer_form = $editable_answer.find('.js-existing-answer-edit-form'),
        $editable_answer_content = $editable_answer.find('.js-answer-content');

    $editable_answer.addClass('-editing');

    $editable_answer_form.off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                var new_answer_content = $answer_textarea.val();

                generate_alert(response.data, 'success');

                $editable_answer_content.html(new_answer_content);

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
    });
}

function edit_question() {
    event.preventDefault();

    var $question = $(this).closest('.js-question'),
        $question_form = $question.find('.js-existing-question-edit-form'),
        $question_title = $question.find('.js-question-title'),
        $question_content = $question.find('.js-question-content'),
        $question_edit_cancel_button = $question.find('.js-question-edit-cancel'),
        $question_title_input = $question.find('.js-question-title-input'),
        $question_content_input = $question.find('.js-question-content-input'),
        old_question_title = $question_title_input.val(),
        old_question_content = $question_content_input.val();

    $question.addClass('-editing');

    $question_form.off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                var new_question_title = $question_form.find('#question_title').val(),
                    new_question_content = $question_form.find('#question_content').val();

                generate_alert(response.data, 'success');

                $question_title.text(new_question_title);
                $question_content.html(new_question_content);

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
                var $deletable_answer = $(this).closest('.answer');
                $deletable_answer.remove();

                generate_alert(response.data, 'success');

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
});
