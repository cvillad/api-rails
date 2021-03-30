class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  
  ErrorMapper.map_errors!({
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  })
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  def render_collection(collection)
    render json: serializer.new(collection)
  end
end
