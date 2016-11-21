module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: [:show]
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end
end
