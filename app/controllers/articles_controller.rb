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
    article = current_user.articles.build(article_params)
    article.save!
    render json: serializer.new(article), status: :created
  end

  def update 
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: serializer.new(article), status: :ok
  rescue ActiveRecord::RecordNotFound
    raise JsonapiErrorsHandler::Errors::Forbidden
    
  end

  def destroy 
    article = current_user.articles.find(params[:id])
    article.destroy!
    head :no_content
  rescue
    raise JsonapiErrorsHandler::Errors::Forbidden
  end

  def serializer 
    ArticleSerializer
  end
  
  private 

  def article_params
     params.require(:data).require(:attributes).permit(:title, :content, :slug)
  end

end