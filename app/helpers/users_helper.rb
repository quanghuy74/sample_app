module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: Settings.user.option.size}
    size = options[:size]
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def check_permit user
    return unless current_user.admin? && !current_user?(user)

    link_to t("user_delete.btn"), user, method: :delete,
      data: {confirm: t("user_delete.confirm")}
  end
end
