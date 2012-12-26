module SessionHelper

  def omniauth_email
    unless session["devise.omniauth_data"] == nil
      session["devise.omniauth_data"].info.email  
    end
  end

  def omniauth_name
    session["devise.omniauth_data"].extra.raw_info.name
  end

  def omniauth_provider
    session["devise.omniauth_data"].provider
  end

  def omniauth_uid
    session["devise.omniauth_data"].uid
  end

  def omniauth_image
    session["devise.omniauth_data"].info.image  
  end

  def is_omniauth_sign_up?
    session["devise.omniauth_data"] != nil  
  end

end
