class Store
  include Mongoid::Document
  include Mongoid::Ranges

  field :name, :type => String
  embeds_ranges :hours
end
