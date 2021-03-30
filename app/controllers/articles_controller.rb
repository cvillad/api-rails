class ArticlesController < ApplicationController
  include Paginable

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

  def serializer 
    ArticleSerializer
  end
  
end