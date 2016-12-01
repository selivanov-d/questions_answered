class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    alias_action :upvote, :downvote, :unvote, :to => :vote

    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer], user_id: user.id

    can :vote, [Question, Answer] do |votable|
      !user.author_of?(votable)
    end

    can :mark_as_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can [:create, :destroy], Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end
  end
end
