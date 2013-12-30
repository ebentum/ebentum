module OmniauthHelper

  def omniauth_form_data
    form_data = ''
    if is_omniauth_sign_up?
      form_data += hidden_field_tag 'user[omniauth_email]', omniauth_email
      form_data += hidden_field_tag 'user[complete_name]',  omniauth_name
      form_data += hidden_field_tag 'user[provider]',       omniauth_provider
      form_data += hidden_field_tag 'user[uid]',            omniauth_uid
      form_data += hidden_field_tag 'token',                omniauth_token
      if omniauth_provider == 'facebook'
        form_data += hidden_field_tag 'expires_at', omniauth_token_expires_at
      else
        form_data += hidden_field_tag 'secret', omniauth_secret
      end
    end
    raw(form_data)
  end

  def omniauth_provider_info
    if is_omniauth_sign_up?
      info = content_tag :div, :class => 'alert alert-info' do
        name = content_tag :strong, omniauth_name
        content_tag :p do
          image_tag(provider_logo, :size => "30x30") + ' ' +
          t(:session_started_as) + ' ' +
          name
        end
      end
    raw(info)
    end
  end

  def provider_logo
    case omniauth_provider
    when 'facebook'
      'f_logo.png'
    when 'twitter'
      't_logo.png'
    else
      nil
    end
  end

  def omniauth_email
    if is_omniauth_sign_up?
      get_omniauth_data.info.email
    end
  end

  def omniauth_name
    if is_omniauth_sign_up?
      get_omniauth_data.info.name
    end
  end

  def omniauth_provider
    get_omniauth_data.provider
  end

  def omniauth_uid
    get_omniauth_data.uid
  end

  def omniauth_token
    get_omniauth_data.credentials.token
  end

  def omniauth_token_expires_at
    get_omniauth_data.credentials.expires_at
  end

  def omniauth_secret
    get_omniauth_data.credentials.secret
  end

  def omniauth_image
    if is_omniauth_sign_up?
      case omniauth_provider
      when 'facebook'
        get_omniauth_data.info.image
      when 'twitter'
        get_omniauth_data.info.image.sub("_normal", "") #sin el '_normal' traerá la imagen 'grande'
      else
        nil
      end
    end
  end

  def is_omniauth_sign_up?
    get_omniauth_data != nil
  end

  def get_omniauth_data
    flash[:omniauth_data]
  end

  def is_account_linked?
    flash[:account_linked] != nil
  end

end
