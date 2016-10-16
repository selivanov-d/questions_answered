class QuestionsController < ApplicationController
  before_action :load_question, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Ваш вопрос успешно создан'
    else
      render :new
    end
  end

  def new
    @question = Question.new
  end

  def show
  end

  private

  def question_params
    params.require(:question).permit(:title, :content)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
