class SignInUserService
  def initialize(params)
    ValidateParameterService.new(params, [:email, :password]).validate!
    @email = params[:email]
    @password = params[:password]
  end

  def sign_in
    user = User.find_by_email @email
    raise Errors::NotFound, "#{@email} not found" if user.nil?
    raise Errors::UnprocessableEntity, 'Invalid credentials' unless user.valid_password? @password
    user.auth_token = TokenService.encode(email: user.email)
    user
  end
end
