class V1::ClassifiedSerializer::UserSerializer < ActiveModel::Serializer
  attributes :id, :fullname

  # has_many :classifieds
end
