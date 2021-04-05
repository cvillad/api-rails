require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:article){create :article}

  describe "GET /index" do
    it "renders a successful response" do
      get :index, params: {article_id: article.id}
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) {{ content: "My awesome comment for article" }}
    let(:invalid_attributes) { { content: "" }}

    context "when not authorized" do 
      subject { post :create, params: {article_id: article.id} }
      it_behaves_like "forbidden_requests"
    end

    context "when authorized" do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers["authorization"] = "Bearer #{access_token.token}" }
      
      context "with valid parameters" do
        it "creates a new Comment" do
          expect {
            post :create,
                params: { article_id: article.id, comment: valid_attributes }, as: :json
          }.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment" do
          post :create,
              params: { article_id: article.id, comment: valid_attributes }, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post :create,
                params: { article_id: article.id, comment: invalid_attributes }, as: :json
          }.to change(Comment, :count).by(0)
        end

        it "renders a JSON response with errors for the new comment" do
          post :create,
              params: { article_id: article.id, comment: invalid_attributes }, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

end
