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

      def embeds_ranges(*args)
        model = args[0].to_sym
        if args[1] && args[1][:index] == true
          args[1].delete(:index)
          index_ranges model
        end
        embeds_many *args
        define_method("in_range_of_#{model}") do |*args|
          self.in_range_of_model(model,*args)
        end
      end

      def in_range_of_model(model,number,state = nil)
        where(model.to_sym.in_range(state) => number)
      end

      def time_in_range_of_model(model,time, state = nil)
        number = time.to_i - time.beginning_of_week.to_i
        in_range_of_model(model,state,number)
      end
    end

    module InstanceMethods

    end 
  end
end
