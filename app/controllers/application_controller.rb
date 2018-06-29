class ApplicationController < ActionController::Base
before_action :prueba
protect_from_forgery with: :exception
def prueba
  I18n.locale =session[:language]
end
def language
  session[:language]=params[:ln]
  respond_to do |format|
    format.html { redirect_to root_path }
  end
end

end
