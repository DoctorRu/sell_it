class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :fullname
end
