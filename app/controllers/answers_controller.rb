class AnswersController < ApplicationController
  include Voted

  before_action :load_answer, only: [:destroy, :update, :mark_as_best]
  before_action :load_question, only: [:create]
  before_action :check_authorship_of_answer, only: [:destroy, :update]
  before_action :check_authorship_of_question, only: [:mark_as_best]

  respond_to :json

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers << @answer
    respond_with(@answer, locals: { answer: @answer })
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def mark_as_best
    @answer.mark_as_best
    respond_with(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:content, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def check_authorship_of_answer
    head :forbidden unless current_user.author_of?(@answer)
  end

  def check_authorship_of_question
    head :forbidden unless current_user.author_of?(@answer.question)
  end
end
