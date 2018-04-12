class ApplicationController < ActionController::API
    include Authenticable

    before_action :authenticate_user_with_token!
end
