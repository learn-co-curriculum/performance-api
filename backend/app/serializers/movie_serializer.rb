class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :director
  has_many :users
  belongs_to :director
end
