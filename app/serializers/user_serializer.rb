class UserSerializer
  include JSONAPI::Serializer
  attributes :login, :name
end