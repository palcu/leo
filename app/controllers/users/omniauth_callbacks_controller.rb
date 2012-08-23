class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]
    
    if user_signed_in?
      #TODO add disconnect
      current_user.provider = auth.provider
      current_user.uid = auth.uid
      current_user.save
      flash[:notice] = "Contul de Facebook a fost conectat cu succes"
      redirect_to users_path
    else
      @user = User.find_for_facebook_oauth(auth, current_user)

      if @user
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
        @user.fb_token = auth['credentials']['token']
        @user.update_from_facebook
        sign_in_and_redirect @user, :event => :authentication
      else
        flash[:error] = "Nu ai contul pe website creat"
        redirect_to root_url
      end
    end
  end
end
