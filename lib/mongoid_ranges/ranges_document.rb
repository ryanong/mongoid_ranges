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

      if respond_to?(:per_page)
        raise 'loop range must be a fixnum' unless per_page.kind_of? Fixnum
        validates_numericality_of :end, :less_than_or_equal_to => per_page
        before_validation :fix_looping
      end

    end

    module ClassMethods

      def in_range(number, state = nil)
        where(Mongoid::Criterion::InRange.new(opts[:state] => state).to_query(number)['$elemMatch'])
      end

      def in_range?(number, state = nil)
        self.in_range(state,number).count > 0
      end
    end

    module InstanceMethods

      def check_for_wrapping
        self.wrap = (self.start > self.end)
      end

      def fix_looping
        self.start  = (self.start > 0)  ? self.start % self.class.loop_range : -1*(self.start % self.class.loop_range)
        self.end    = (self.end > 0)    ? self.end % self.class.loop_range   : -1*(self.end % self.class.loop_range)
      end
    end 
  end
end

