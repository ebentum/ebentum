module EventsHelper

  def og_title(title)
    if title
      title
    else
      'ebentum'
    end
  end

  def og_description(description)
    if description
      description
    else
      t(:meta_description_default)
    end
  end

  def og_type(type)
    if type
      type
    else
      'website'
    end
  end

  def og_url(url)
    if url
      url
    else
      'http://www.ebentum.com'
    end
  end

  def og_image(image)
    if image
      image
    else
      'http://www.ebentum.com/images/logo.png'
    end
  end

end