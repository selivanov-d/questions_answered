class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  def author_of?(object)
    id == object.user_id
  end

  def self.find_for_oauth(auth)
    return unless auth.is_a?(Hash) && OmniAuth::AuthHash.new(auth).valid?

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.send_questions_digest
    questions = Question.select(:id, :title, :content).where('created_at > ?', Time.now - 100.day).to_a

    if questions.any?
      find_each.each do |user|
        QuestionsDailyDigestMailer.digest(user, questions).deliver_later
      end
    end
  end
end
