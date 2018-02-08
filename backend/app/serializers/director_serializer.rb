class DirectorSerializer < ActiveModel::Serializer
  attributes :id, :name, :movies
  has_many :movies
end
