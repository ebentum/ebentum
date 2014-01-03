class AdminController < ApplicationController

  before_filter :admin_user

  def admin_user
    if current_user.email != 'andermujika@gmail.com'
      redirect_to '/'
    end
  end

  def update_fulltext_index
    User.update_ngram_index
    render :json => true
  end

end
