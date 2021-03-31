class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  AuthorizationError = Class.new(StandardError)

  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound',
    "ActiveRecord::RecordInvalid" => "JsonapiErrorsHandler::Errors::Invalid",
    "ApplicationController::AuthorizationError" => "JsonapiErrorsHandler::Errors::Forbidden",
    "UserAuthenticator::AuthenticationError" => "JsonapiErrorsHandler::Errors::Unauthorized"
  })

  before_action :authorize!

  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }
  rescue_from ActiveRecord::RecordInvalid, with: lambda { |e| handle_validation_error(e) }

  def handle_validation_error(error)
    error_model = error.try(:model) || error.try(:record)
    mapped = JsonapiErrorsHandler::Errors::Invalid.new(errors: error_model.errors)
    render_error(mapped)
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
