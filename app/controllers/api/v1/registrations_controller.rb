class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action  :verify_authenticity_token
  before_action :authenticate_user!, except: [:create,:destroy]

    # eval(IO.read('doc/api_doc/auth/sign_up.html'), binding)
  def create
  	# byebug
    user = User.new(registration_params)
    if user.save!

      return render json: {status: 200, data: {user: user}, :message =>"Successfuly Signup"}
    else
      warden.custom_failure!
      return render json: {status: 401, data: {user: nil, errors: user.errors}, :message =>"SignUp Rollback"}
    end
  end

    def update
    begin
       user =  current_user
       user.email = params[:user][:email] if params[:user][:email].present?
       user.password = params[:user][:password] if params[:user][:password].present?
       if user.save!
        return render json: {status: 200, data: {user: user, location: location}, :message =>"User Profile Successfully Updated"} 
      else
        # error_section
        rescue_section
      end
    rescue
      rescue_section
    end
  end 

  
  private
   def registration_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
