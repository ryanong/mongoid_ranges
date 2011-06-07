# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Symbol #:nodoc:
      module Inflections #:nodoc:
        def in_range state
          Criterion::InRange.new(:key => self, :state => state)
        end
      end
    end
  end
end
