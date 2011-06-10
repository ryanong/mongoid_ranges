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

        set_callback(:save,:before) do |document|
          document.send(model).all.each do |range|
            range.run_callbacks :save
          end
        end
        
        set_callback(:validation,:before) do |document|
          document.send(model).all.each do |range|
            range.run_callbacks :validation
          end
        end

        embeds_many *args
        define_method("in_range_of_#{model}") do |*args|
          self.in_range_of(model,*args)
        end
      end

      def in_range_of(model,number,state = nil)
        where(model.to_sym.in_range(state) => number)
      end

      def time_in_range_of(model,time, state = nil)
        number = time.to_i - time.beginning_of_week.to_i
        in_range_of(model,state,number)
      end

    end

    module InstanceMethods
      def group_hours(names)
        group = {}
        interval = DealershipHours.loop_range / names.size
        hours.each do |range|
          range_start = range.start % interval
          range_end   = range.end % interval
          hash = (range_start.to_s+range_end.to_s+range.states.join)
          group[hash] ||= {
            :start      => range_start,
            :end        => range_end,
            :start_name => names[(range.start.to_i / interval).to_i],
            :end_name   => names[(range.end.to_i / interval).to_i],
            :states     => range.states,
            :ranges     => []}
            group[hash][:ranges] << range
            group[hash][:end_name] = names[(range.end / interval).to_i]
        end
        group
      end
    end 
  end
end
