class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers << @answer

    unless @answer.save
      head :no_content
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      render json: { message: 'Ваш ответ удалён'.force_encoding('UTF-8') }, status: :ok
      # не получилось заставить ActiveSupport::JSON.encode() с кириллицей без string.force_encoding('UTF-8')
    else
      render json: { message: 'Удалить можно только свой ответ'.force_encoding('UTF-8') }, status: :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:content)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
