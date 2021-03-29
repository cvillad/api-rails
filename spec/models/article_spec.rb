require 'rails_helper'

RSpec.describe Article, type: :model do
  describe "#validations" do
    let(:article) { build(:article) }
    it "test that factory is valid" do
      expect(article).to be_valid
    end

    it "has an invalid title" do 
      article.title = ""
      expect(article).not_to be_valid
      expect(article.errors[:title]).to include("can't be blank")
    end

    it "has an invalid content" do 
      article.content = ""
      expect(article).not_to be_valid
      expect(article.errors[:content]).to include("can't be blank")
    end

    it "has an invalid slug" do 
      article.slug = ""
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include("can't be blank")
    end

    it "validates the uniqueness of the slug" do 
      article = create(:article)
      article2 = build(:article, slug: article.slug)
      expect(article2).not_to be_valid
      expect(article2.errors[:slug]).to include("has already been taken")
    end
  end
end
