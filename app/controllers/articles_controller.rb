class ArticlesController < ApplicationController
  def index
    articles = Article.all
    render json: serializer.new(articles)
  end

  def show
  end

  def serializer 
    ArticleSerializer
  end
end