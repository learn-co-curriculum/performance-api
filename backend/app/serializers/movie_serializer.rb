class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :users
  belongs_to :director
end
