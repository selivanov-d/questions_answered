class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  before_action :load_question, only: [:show]

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with @question, host: "#{request.protocol}#{request.host}", serialized: SingleQuestionSerializer
  end

  def create
    @question = Question.create(question_params)
    current_resource_owner.questions << @question
    respond_with @question
  end

  protected

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
