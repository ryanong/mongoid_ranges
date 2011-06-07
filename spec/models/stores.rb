class Store
  include Mongoid::Document
  include Mongoid::Ranges

  field :name, :type => String
  embeds_many :hours
end
