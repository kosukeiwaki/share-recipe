class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  def index

  end

  def new
    @user = User.new
  end

  def create

    if params[:sns_auth] == 'true'
      pass = Devise.friendly_token
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
    end
  
    @user = User.new(sign_up_params)
    unless @user.valid?
      flash.now[:alert] = @user.errors.full_messages
      render :new and return
    end
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user]["password"] = params[:user][:password]
    @address = @user.build_address
    render :new_address

    end



    def create_address
      @user = User.new(session["devise.regist_data"]["user"])
      @address = Address.new(address_params)
      unless @address.valid?
        flash.now[:alert] = @address.errors.full_messages
        render :new_address and return
      end
      @user.build_address(@address.attributes)
      @user.save
      sign_in(:user, @user)
      redirect_to root_path
    end

 
  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def address_params
    params.require(:address).permit(:zip,:prefecture, :city, :block, :building, :phone_number,
    :lastname, :firstname, :lastname_kana, :firstname_kana)
  end

end