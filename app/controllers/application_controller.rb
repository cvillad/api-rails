class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  AuthorizationError = Class.new(StandardError)

  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    "ActiveRecord::RecordInvalid" => "JsonapiErrorsHandler::Errors::Invalid",
    "ApplicationController::AuthorizationError" => "JsonapiErrorsHandler::Errors::Forbidden",
  })

  before_action :authorize!

  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }
  rescue_from UserAuthenticator::Standard::AuthenticationError, with: lambda {|e| handle_authentication_error(e)}
  rescue_from UserAuthenticator::Oauth::AuthenticationError, with: lambda {|e| handle_oauth_error(e)}

  def handle_validation_error(error)
    error_model = error.try(:model) || error.try(:record)
    mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: error_model.errors)
    render_error(mapped)
  end

  def handle_oauth_error(error)
    error = {
      "status": 401,
      "source": { "pointer": "access_token" },
      "title":  "Authentication code is invalid",
      "detail": "You must provide valid code in order to exchange it for token."
    }
    render json: { "errors": [ error ] }, status: 401
  end

  def handle_authentication_error(error)
    error = {
      "status": 401,
      "source": { "pointer": "/data/attributes/password" },
      "title": "Invalid login or password",
      "detail": "You must provide valid credentials.",
    }
    render json: {errors: [error]}, status: 401
  end

  def render_collection(collection)
    render json: serializer.new(collection)
  end

  private 

  def authorize! 
    raise AuthorizationError unless current_user
  end

  def access_token 
    provided_token = request.authorization&.gsub(/\ABearer\s/,"")
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end
end
