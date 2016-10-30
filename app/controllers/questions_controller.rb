class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Ваш вопрос успешно создан'
    else
      render :new
    end
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Ваш вопрос удалён'
    else
      redirect_to @question, notice: 'Удалить можно только свой вопрос'
    end
  end

  def update
    old_all_attachments = @question.attachments.to_a

    if current_user.author_of?(@question)
      if @question.update(question_params)
        new_all_attachments = @question.attachments.to_a

        new_attachments = new_all_attachments - old_all_attachments

        newly_attached = {}

        new_attachments.each do |attachment|
          newly_attached[attachment.file.identifier] = attachment.file.url
        end

        render json: { status: 'success', data: { message: 'Ваш вопрос успешно изменён', newly_attached: newly_attached } }, status: :ok
      else
        render json: { status: 'error', data: @question.errors }, status: :ok
      end
    else
      render json: { message: 'Отредактировать можно только свой вопрос' }, status: :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
