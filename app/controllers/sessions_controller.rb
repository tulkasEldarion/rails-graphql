class SessionsController < ApplicationController
  skip_before_action :authenticate_user_with_token!, only: %i[create]

  def create
    user = params[:email].present? && User.find_by(email: params[:email])

    unless user && user.valid_password?(params[:password])
      error = Error.new(
        403, 'Invalid Credentials', 'invalidCredentials'
      )
      return render status: :forbidden,
                    json: error.to_json
    end

    sign_in user, store: false
    user.generate_authentication_token!(replace: false)
    user.save
    render  status: :created,
            json: create_session(user).to_json
  end

  protected

  def create_session(user)
    {
      authToken: user.auth_token,
      accountIdentifier: user.id.to_s,
      email: user.email,
    }
  end
end
