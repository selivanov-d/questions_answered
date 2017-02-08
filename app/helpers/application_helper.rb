module ApplicationHelper
  def current_permissions_as_hash
    Digest::MD5.hexdigest(current_ability.permissions.to_s)
  end
end
