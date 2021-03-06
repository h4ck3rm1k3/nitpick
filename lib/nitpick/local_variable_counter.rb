module Nitpick
  class LocalVariableCounter < Nitpicker
    def initialize(klass, meth)
      super
      # uses.succ each time a local variable is referenced or assigned to
      # calls.succ each time a message is sent to a lvar (foo.bar)
      @lvars = Hash.new {|h,k| h[k] = {:uses => 0, :calls => 0}}
      @args = []
    end
    
    def uses(name)
      @lvars[name][:uses]
    end
    
    def use(name)
      @lvars[name][:uses] += 1
    end
    
    def call(name)
      @lvars[name][:calls] += 1
    end
    
    def process_lasgn(exp)
      name = exp.shift
      value = exp.shift
      
      use name
      process(value)
      
      s(:lasgn, name, value)
    end
    
    def process_iasgn(exp)
      name = exp.shift
      value = exp.shift
      
      process(value)
      
      s(:iasgn, name, value)
    end
    
    def process_call(exp)
      recv = process(exp.shift)
      meth = exp.shift
      args = process(exp.shift)

      call recv.last if recv.first == :lvar
      
      s(:call, recv, meth, args)
    end
    
    def process_lvar(exp)
      name = exp.shift
      use name
      s(:lvar, name)
    end
    
    def process_args(exp)
      exp.each do |arg|
        next unless arg.is_a? Symbol
        
        name = arg.to_s.gsub(/^\*/, '')
        next if name == ""
        
        @args << name.to_sym
        use name.to_sym
      end
      
      exp.clear
      
      s(:args, *@args)
    end
    
    def process_block_arg(exp)
      name = exp.shift
      @args << name
      use name
      s(:block_arg, name)
    end
  end
end