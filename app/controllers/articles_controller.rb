class ArticlesController < ApplicationController
  include Paginable
  
  skip_before_action :authorize!, only: [:index, :show]

  def index
    articles = Article.recent.paginate(
      page: pagination_params[:number], 
      per_page: pagination_params[:size]
    )
    render_collection(articles)
  end

  def show
    article = Article.find(params[:id])
    render json: serializer.new(article)
  end

  def create 
    Article.create!(article_params)
  end

  def serializer 
    ArticleSerializer
  end
  
  private 

  def article_params
     ActionController::Parameters.new
  end

end