module ApplicationHelper

  def head_title(title)
    if title
      title
    else
      'ebentum'
    end
  end

  def meta_description(description)
    if description
      description
    else
      t(:meta_description_default)
    end
  end

  def meta_keywords(description)
    if description
      t(:meta_keywords_default)+', '+description.gsub(/[^0-9A-Za-z]/, ' ').split(' ').join(', ')
    else
      t(:meta_keywords_default)
    end
  end

  def get_body_class
    if @native_app == true
      'native-app'
    else
      'normal'
    end
  end

end
