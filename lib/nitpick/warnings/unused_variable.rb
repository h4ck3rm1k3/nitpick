module Nitpick
  module Warnings
    class UnusedVariable < SimpleWarning
      attr_reader :variable

      def initialize(variable)
        @variable = variable
      end

      def ==(other)
        other.is_a?(self.class) && @variable == other.variable
      end
      
      def message
        "The variable #{@variable.inspect} is unused."
      end
    end
  end
end
