class ApplicationController < ActionController::API
  include JsonapiErrorsHandler

  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from ActiveRecord::RecordNotFound, with: lambda { |e| handle_error(e) }

  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  })

  def render_collection(collection)
    render json: serializer.new(collection)
  end

  private 

  def authentication_error 
    error = {
      "status": "401",
      "source": { "pointer": "/code" },
      "title": "Authentication code is invalid",
      "detail": "You must provide valid code in order to exchange it for token."
    }
    render json: {"errors"=> [error]}, status: 401
  end
end
