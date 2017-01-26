class User < ActiveRecord::Base
  validates :name, :uid, :provider, presence: true
  validates_with UserRoleValidator

  ROLES = %w( instructor student unknown )

  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by(uid: auth_hash["uid"], provider: auth_hash["provider"])
    if !user.nil?
      return user
    else
      # no user found, do something here
      user = User.new
      user.uid = auth_hash["uid"]
      user.provider = auth_hash["provider"]
      user.name = auth_hash["info"]["name"]
      # user.email = auth_hash["info"]["email"]

      if user.save
        return user
      else
        return nil
      end
    end
  end

  def accept_invite(invite)
    raise ArgumentError.new("Invite is not valid") unless invite.valid?

    transaction do
      update!(role: invite.role)
      invite.update!(accepted: true)
    end
  end
end
