class Ability
  include CanCan::Ability

  def initialize(user)
    return guest_rules unless user
    unauthorized_rules unless user.authorized?

    instructor_rules if user.instructor?
    student_rules if user.student?
  end

  def guest_rules
  end

  def unauthorized_rules
  end

  def instructor_rules
    [Cohort, Repo, Student, Submission, User, UserInvite].each do |model|
      can :create, model
      can :read, model
      can :update, model
      can :destroy, model
    end
  end

  def student_rules
  end
end
