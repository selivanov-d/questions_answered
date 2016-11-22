class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  include Voted

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
    @comment = @question.comments.build
    gon.push({
      question_id: @question.id
    })
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
    if current_user.author_of?(@question)
      if @question.update(question_params)
        question_form_html = render_to_string partial: 'questions/form_edit'
        question_content_html = render_to_string partial: 'questions/question-content'

        render json: { status: 'success', data: {
          message: 'Ваш вопрос успешно изменён',
          question_form_html: question_form_html,
          question_content_html: question_content_html
        } }, status: :ok
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
