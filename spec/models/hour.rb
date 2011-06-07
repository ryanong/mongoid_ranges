class Hour
  include Mongoid::Document
  include Mongoid::RangesDocument

  embedded_in :stores

end
