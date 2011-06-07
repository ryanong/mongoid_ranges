# encoding: utf-8
module Mongoid #:nodoc:
  module Ranges
    extend ActiveSupport::Concern
    
    included do

    end

    module ClassMethods
      def index_ranges(*ranges)
        ranges.each do |range|
          index "#{range}.states"
          index "#{range}.start"
          index "#{range}.end"
          index "#{range}.wrap"          
        end
      end
    end

    module InstanceMethods
      def state_in_range(state,range)
        state
        # ...
      end
    end 
  end
end
