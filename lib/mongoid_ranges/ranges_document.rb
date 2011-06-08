# encoding: utf-8
module Mongoid #:nodoc:
  module RangesDocument
    extend ActiveSupport::Concern

    included do
      
      field :states   ,:type => Array
      field :start    ,:type => Integer
      field :end      ,:type => Integer
      field :wrap     ,:type => Boolean

      before_save :check_for_wrapping
    end

    module ClassMethods

      def in_range(number, state = nil)
        where(Mongoid::Criterion::InRange.new(opts[:state] => state).to_query(number)['$elemMatch'])
      end

      def in_range?(number, state = nil)
        self.in_range(state,number).count > 0
      end

      def set_loop_range(range)
        raise 'loop range must be a fixnum' unless range.kind_of? Fixnum
        @@loop_range = range
        validates_numericality_of :end, :less_than_or_equal_to => @@loop_range
        before_validation :fix_looping
      end

    end

    module InstanceMethods

      def check_for_wrapping
        self.wrap = (self.start > self.end)
      end

      def fix_looping
        self.start  = (self.start > 0)  ? self.start % @@loop_range : -1*(self.start % @@loop_range)
        self.end    = (self.end > 0)    ? self.end % @@loop_range   : -1*(self.end % @@loop_range)
      end
    end 
  end
end

