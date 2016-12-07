class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer

  before_action :load_question, only: [:index]

  def index
    respond_with @question.answers, host: "#{request.protocol}#{request.host}"
  end

  protected

  def load_question
    @question = Question.find(params[:question_id])
  end
end
