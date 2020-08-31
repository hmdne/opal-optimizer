module Opal; class Optimizer

module Helpers
  include RKelly::Nodes

  def parse_js(code)
    RKelly.parse(code)
  end
end

end; end

class RKelly::Nodes::Node
  def value_path?(*patterns)
    current = self
    patterns.all? do |pattern|
      current = current.value
      pattern === current
    end
  end

  def accept (visitor, &block)
    if @destroyed_by
      if RKelly::Visitors::ECMAVisitor === visitor
        "/* destroyed: #{@destroyed_by} */0"
      end
    else
      super
    end
  end

  def destroy! by
    @destroyed_by = by
  end
end
