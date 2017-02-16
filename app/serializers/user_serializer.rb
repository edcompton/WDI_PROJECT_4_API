class UserSerializer < ActiveModel::Serializer
  attributes :email, :password_digest, :id
end
