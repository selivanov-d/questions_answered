function edit_answer() {
    event.preventDefault();

    $('.js-answer-content, .js-answer-edit-form, .js-edit-answer').toggleClass('-active');

    $('.js-existing-answer-edit-form').off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                $('.js-notice').text(response.data);
                $('.js-answer-content').html($('.js-answer-edit-form').find('.js-existing-answer-content').val());
                $('.js-answer-content, .js-answer-edit-form, .js-edit-answer').toggleClass('-active');
                break;
            case 'error':
                var errors_array = get_errors_array(response.data);
                $('.js-alert').html(errors_to_list(errors_array));
                break;
        }
    });
}

function edit_question() {
    event.preventDefault();

    $('.js-existing-question-content, .js-edit-question').toggleClass('-active');

    $('.js-existing-question-edit-form').off('ajax:success').on('ajax:success', function (event, response) {
        switch (response.status) {
            case 'success':
                var new_question_title = $('.js-existing-question-edit-form').find('#question_title').val();
                var new_question_content = $('.js-existing-question-edit-form').find('#question_content').val();

                $('.js-notice').text(response.data);

                $('.js-question-title').text(new_question_title);
                $('.js-question-content').html(new_question_content);

                $('.js-existing-question-content, .js-existing-question-edit-form, .js-edit-question').toggleClass('-active');
                break;
            case 'error':
                var errors_array = get_errors_array(response.data);
                $('.js-alert').html(errors_to_list(errors_array));
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
    var errors_html = '<ul>';

    errors_array.forEach(function (error_message) {
        errors_html += '<li>' + error_message + '</li>';
    });

    errors_html += '</ul>';

    return errors_html;
}

$(document).on('ready', function () {
    $('.js-delete-answer').on('click', function (e) {
        e.preventDefault();

        var url = this.href,
            answer_id = $(this).closest('.answer').data('answer-id');

        $.ajax(
            {
                url: url,
                dataType: 'json',
                method: 'post',
                data: {
                    '_method': 'delete'
                },
                statusCode: {
                    200: function (response) {
                        $('.js-notice').text(response.message);
                        $('.answer[data-answer-id="' + answer_id + '"]').remove();
                    },
                    403: function () {
                        $('.js-alert').text(response.message);
                    }
                }
            }
        );
    });

    $('.js-edit-answer').on('click', edit_answer);

    $('.js-edit-question').on('click', edit_question)
});
