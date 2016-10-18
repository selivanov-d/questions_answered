class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:destroy]
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers << @answer

    if @answer.save
      redirect_to @question, notice: 'Ваш ответ сохранён'
    else
      render :new
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      redirect_to @answer.question, notice: 'Ваш ответ удалён'
    else
      redirect_to @answer.question, notice: 'Удалить можно только свой ответ'
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
