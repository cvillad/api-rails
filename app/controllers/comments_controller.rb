class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  before_action :load_article
  # GET /comments
  def index
    comments = @article.comments.paginate(
      page: params[:page], 
      per_page: params[:per_page]
    )
    render json: serializer.new(comments)
  end

  # POST /comments
  def create
    @comment = @article.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      render json: @comment, status: :created, location: @article
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end


  private
  # Only allow a list of trusted parameters through.
  def load_article 
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def serializer 
    CommentSerializer
  end
end
