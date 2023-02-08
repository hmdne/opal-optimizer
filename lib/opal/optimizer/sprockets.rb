require 'opal/optimizer'

require 'opal-sprockets'

module Opal; class Optimizer

module Sprockets
  def self.call input
    Opal::Optimizer.new(input[:data]).optimize
  rescue NonOpalArgumentError
    input[:data]
  end
end

end; end

Sprockets.register_bundle_processor 'application/javascript', Opal::Optimizer::Sprockets
