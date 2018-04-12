module Authenticable
  # Devise methods overwrites
  def current_user
    auth_token =  request.headers['Authorization'].present? &&
                  request.headers['Authorization'].sub(/Bearer /, '')

    @current_user ||= User.find_by(auth_token: auth_token)
  end

    # rubocop:disable all
    def authenticate_user_with_token!
      auth_token =  request.headers['Authorization'].present? &&
                    request.headers['Authorization']

      error = false
      if !auth_token
        error = Error.new(
          401, 'Empty Authorization header', 'missingAuthHeader'
        )
      elsif !auth_token.start_with? 'Bearer '
        error = Error.new(
          401, 'Unsupported authentication system', 'unsupportedAuthSystem'
        )
      elsif !auth_token.start_with? 'Bearer '
        error = Error.new(
          401, 'Token not found in Authorization header', 'missingAuthToken'
        )
      elsif token_expired?
        error = Error.new(
          401, 'Authentication token is expired', 'authTokenExpired'
        )
      elsif !user_signed_in?
        error = Error.new(
          401,
          'Your session has been expired please tap the OK button to re-initiate',
          'invalidAuthToken'
        )
      end

      render status: :unauthorized, json: error.to_json if error
    end
    # ruboocop:enable

    def user_signed_in?
      current_user.present? && !token_expired?
    end

    private

    def token_expired?
      Time.current - current_user.current_sign_in_at > 14400
    end
  end
