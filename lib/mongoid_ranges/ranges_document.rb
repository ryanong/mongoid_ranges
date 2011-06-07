# encoding: utf-8
module Mongoid #:nodoc:
  module RangesDocument
    extend ActiveSupport::Concern

    included do
      field :states   ,:type => Array
      field :start    ,:type => Integer
      field :end      ,:type => Integer
      field :wrap     ,:type => Boolean

      before_save :check_wrap
    end

    module ClassMethods
      def in_range(range)
        where()
      end
    end

    module InstanceMethods
      private
      def check_wrap()
        self.wrap = (self.start > self.end)
      end
    end 
  end
end

