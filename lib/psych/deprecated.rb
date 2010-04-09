module Psych
  module DeprecatedMethods # :nodoc:
    attr_accessor :taguri
    attr_accessor :to_yaml_style
  end

  def self.quick_emit thing, opts = {}, &block # :nodoc:
    target = eval 'self', block.binding
    target.extend DeprecatedMethods
    metaclass = class << target; self; end
    metaclass.send(:define_method, :encode_with) do |coder|
      target.taguri        = coder.tag
      target.to_yaml_style = coder.style
      block.call coder
    end
    target.psych_to_yaml unless opts[:nodump]
  end
end
