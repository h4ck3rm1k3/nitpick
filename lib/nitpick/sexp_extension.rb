module Nitpick
  module SexpExtension
    define_method :"!~" do |pattern|
      !(self =~ pattern)
    end
  end
end