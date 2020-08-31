require 'forwardable'

module Opal; class Optimizer

class Step
  include Helpers
  extend Forwardable

  def_delegators :@optimizer, *Optimizer.public_instance_methods(false)

  def initialize optimizer
    @optimizer = optimizer
  end

  def run
    raise NotImplementedError
  end
end

end; end

require 'opal/optimizer/step/tree_shaking'
require 'opal/optimizer/step/collapse_stubs'
