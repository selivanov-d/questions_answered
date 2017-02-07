module ApplicationHelper
  def permissions_as_hash_for(user)
    Digest::MD5.hexdigest(Ability.new(user).permissions.to_s)
  end
end
