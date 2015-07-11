module UsersHelper
  # Return gavatar for given user
  def gravatar_for(user, options)
  	if user.avatar?
    	image_tag(user.avatar.url, class: "gravatar")
    else
    	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    	size = options[:size]
    	gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    	image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end

  def avatar_for(user)
  	if user.avatar?
    	image_tag(user.avatar.url, class: "avatar", style: "width: 200px; height: 200px;")
    else
    	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
	    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=200"
	    image_tag(gravatar_url, alt: user.name, class: "avatar")
    end
  end
end
