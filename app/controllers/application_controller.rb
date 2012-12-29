class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  private

  def after_sign_out_path_for(user)
    "/"
  end

  def after_sign_in_path_for(user)
      root_path
  end
end
