class ApplicationController < ActionController::API
  def render_collection(collection)
    render json: serializer.new(collection)
  end
end
