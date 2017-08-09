class Ability
  include CanCan::Ability

  def initialize(user)
    instructor_rules if user.instructor?
  end

  def instructor_rules
    [Cohort, Repo, Student, Submission, User, UserInvite].each do |model|
      can :read, model
    end
  end
end
