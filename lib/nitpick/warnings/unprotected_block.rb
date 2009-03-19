module Nitpick
  module Warnings
    class UnprotectedBlock < SimpleWarning
      attr_reader :condition, :yes_branch, :no_branch
      
      def initialize(*args)
        @condition, @yes_branch, @no_branch = args
      end
      
      def matches?
        # raise "YES: #{yes_branch.inspect}"
        yes_branch =~ s(:yield) && condition !~ s(:fcall, :block_given?)
      end
      
      def ==(other)
        yes_branch == other.yes_branch && no_branch == other.no_branch
      end
      
      def message
        "A block is being yielded to without a check for block_given?"
      end
    end
  end
end