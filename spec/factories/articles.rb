FactoryBot.define do
  factory :article do
    title { "Sample article" }
    content { "Sample content" }
    slug { "sample-article" }
  end

  sequence :slug do
    "sample-article"
  end
end