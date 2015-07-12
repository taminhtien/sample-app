module UsersHelper
  def avatar(user)
  	if user.avatar?
    	user.avatar.url
    else
    	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}"
    end
  end
end
