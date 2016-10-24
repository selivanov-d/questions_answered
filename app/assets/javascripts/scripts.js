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
});
