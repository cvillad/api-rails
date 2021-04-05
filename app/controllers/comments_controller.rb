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
    @comment.save!
    render json: serializer.new(@comment), status: :created, location: @article
  end


  private
  # Only allow a list of trusted parameters through.
  def load_article 
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:data).require(:attributes).permit(:content) || 
    ActionController::Parameters.new
  end

  def serializer 
    CommentSerializer
  end
end
