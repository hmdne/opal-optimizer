require 'set'

module Opal; class Optimizer; class Step

class CollapseStubs < Step
  def run
    # We can't collapse when no corelib present.
    return unless corelib

    stubs = Set.new

    nodes = corelib_calls["add_stubs"] || []
    nodes.each do |node|
      if opal_version >= 1.4
        stubs += node.arguments.value.first.value[1..-2].split(',').map(&"$".method(:+))
      else
        stubs += node.arguments.value.first.value.map do |i|
          i.value.value.gsub(/['"]/, '')
        end
      end

      node.destroy! "CollapseStubs"
    end

    stubs -= ["__send__", "class", "!=", "equal?", "==", "__id__", "!",
              "initialize", "eql?", "instance_eval", "instance_exec",
              "singleton_method_added", "singleton_method_removed",
              "singleton_method_undefined", "method_missing"].map(&"$".method(:+))

    stubs -= ["$respond_to_missing?"] if opal_version >= 1.1


    new_stub_code = <<~JAVASCRIPT
      var stubs = '#{stubs.to_a.join(',')}'.split(','), stubs_obj = {};
      for (var i = 0; i < stubs.length; i++)
        stubs_obj[stubs[i]] = {value: Opal.stub_for(stubs[i]), enumerable: false, configurable: true, writable: true};
      Object.defineProperties(Opal.BasicObject.$$prototype, stubs_obj);
    JAVASCRIPT

    new_stub_code = parse_js(new_stub_code)

    corelib_source.value += new_stub_code.value
  end
end

end; end; end
