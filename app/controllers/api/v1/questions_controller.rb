class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  before_action :load_question, only: [:show]

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, serializer: SingleQuestionSerializer
  end

  def create
    respond_with current_resource_owner.questions.create(question_params)
  end

  protected

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
