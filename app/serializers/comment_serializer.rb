class CommentSerializer
  include JSONAPI::Serializer
  attributes :content
  has_one :article 
  has_one :user
end