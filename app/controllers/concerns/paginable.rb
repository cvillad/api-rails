module Paginable 
  extend ActiveSupport::Concern 

  def pagination_params
    if params[:page].nil?  
      {page: {number: 1, size: 99999}}
    else
      params.permit![:page]
    end
  end

end