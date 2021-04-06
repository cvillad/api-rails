class RegistrationsController < ApplicationController
  skip_before_action :authorize!, only: :create

  def create
    user = User.new(registration_params.merge(provider: "standard"))
    user.save! 
    render json: serializer.new(user), status: :created
  end

  def serializer 
    UserSerializer
  end

  private 
  def registration_params 
    params.require(:data).require(:attributes).permit(:login, :password) || ActionController::Parameters.new
  end
end