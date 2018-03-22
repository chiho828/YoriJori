class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  
  protected
  
  def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
  
  def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end
  
  def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end
end