class AnswersController < ApplicationController
  before_action :load_answer, only: [:show]
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Ваш ответ сохранён'
    else
      render :new
    end
  end

  def show
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
