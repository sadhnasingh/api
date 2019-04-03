class Api::V1::SessionsController < Api::V1::ApiController
	skip_before_action  :verify_authenticity_token 
  # before_action :authenticate_user!, only: [:destroy]
    before_action :authenticate_user!, except: [:create,:destroy]
  def create
    # begin
      email = params[:user][:email]
      password = params[:user][:password]
      return render json:{data: {user: nil}, message: "The request must contain the email and password."},status: 401 unless email && password
      @user = User.where(email: email).first
      return render json:{data: {user: nil}, message: "Invalid email or password"},status: 401 if @user.blank?
      return render json:{data: {user: nil},  message: "Invalid email or password"},status: 401 if not @user.valid_password?(password)
      sign_in @user

      # @user = @user.as_json(only: [:id,:email, :email,:name,:address,:role,:authentication_token, :image, :created_at])
      return render json: {user: @user, message: "Login Successful"},status: 200
    # rescue
    #   rescue_section
    # end
  end


# eval(IO.read('doc/api_doc/auth/sign_out.html'), binding)
    def destroy
      current_user.authentication_token = nil
      current_user.save
      return render json: {status: 200, data: nil, message: "Successfuly Log out"}
    end 

end