class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :movies
  has_many :movies
end
