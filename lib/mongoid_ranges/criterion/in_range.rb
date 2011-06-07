# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    # Complex criterion are used when performing operations on symbols to get
    # get a shorthand syntax for where clauses.
    #
    # Example:
    #
    # <tt>{ :field => { "$lt" => "value" } }</tt>
    # becomes:
    # <tt> { :field.lt => "value }</tt>
    class InRange
      attr_accessor :key, :operator, :states

      # Create the new complex criterion.
      def initialize(opts = {})
        @key,@state = opts[:key],opts[:state].to_s
        @operator = '$elemMatch'
      end

      def make_hash v
        {
          '$elemMatch' => {
            '$or' => [{
              :states => @state,
              :start  => {'$lte' => v},
              :end    => {'$gte' => v},
              :wrap   => false
            },{
              :states => @state,
              :start  => {'$gte' => v},
              :end    => {'$lte' => v},
              :wrap   => true
            }]
          }
        }
      end

      def hash
        [@key,@operator,@states].hash
      end

      def eql?(other)
        self == (other)
      end

      def ==(other)
        return false unless other.is_a?(self.class)
        self.key == other.key && self.operator == other.operator && self.states == other.states
      end
    end
  end
end

