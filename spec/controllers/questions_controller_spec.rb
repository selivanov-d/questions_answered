require 'rails_helper'
require 'shared_examples/controllers/voted'

RSpec.describe QuestionsController, type: :controller do
  it_should_behave_like 'voted'

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 5, question: question, user: user) }

    before { get :show, params: { id: question } }

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'populates an array of all answers for current question' do
      expect(assigns(:question).answers).to match_array(answers)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    sign_in_user

    let(:questions) { create_list(:question, 2) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      before :each do
        post :create, params: { question: attributes_for(:question) }
      end

      it 'assigns last created question to @question' do
        expect(assigns(:question)).to eq(Question.last)
      end

      it 'saves new question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not saves new question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }

    context 'question\'s author' do
      it 'assigns requested question to @question' do
        delete :destroy, params: { id: question }
        expect(assigns(:question)).to eq(question)
      end

      it 'deletes a question' do
        expect { delete :destroy, params: { id: question } }.to change(@user.questions, :count).by(-1)
      end

      it 'renders questions index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not question\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)
      end

      it 'does not deletes a question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'renders questions show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:question) { create(:question, user: @user) }

    context 'question\'s author' do
      context 'with valid attributes' do
        before do
          patch :update, params: { id: question, question: { title: 'New question title', content: 'New question content' } }, format: :json
        end

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'changes question\'s attributes' do
          question.reload
          expect(question.title).to eq 'New question title'
          expect(question.content).to eq 'New question content'
        end

        it 'receives JSON response with 200 HTTP-header' do
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json')
        end
      end

      context 'with invalid attribures' do
        before do
          patch :update, params: { id: question, question: { title: '', content: '' } }, format: :json
        end

        it 'assigns requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'does not updates a question' do
          question.reload
          expect(question.title).to_not eq ''
          expect(question.content).to_not eq ''
        end

        it 'receives JSON response with 200 HTTP-header' do
          error_response_json = {
            errors: assigns(:question).errors
          }.to_json

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq error_response_json
        end
      end
    end

    context 'not questions\'s author' do
      before do
        user2 = create(:user)
        sign_out(@user)
        sign_in(user2)

        patch :update, params: { id: question, question: { title: 'New question title', content: 'New question content' } }, format: :js
      end

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'does not updates a question' do
        question.reload
        expect(question.content).to_not eq 'New question title'
        expect(question.content).to_not eq 'New question content'
      end

      it 'redirects to show view' do
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
