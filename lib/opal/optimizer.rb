require "opal/optimizer/version"
require "rkelly"
require "opal/optimizer/helpers"

require "pry"

module Opal
  class Optimizer
    include Helpers

    attr_accessor :ast, :opal_version, :corelib, :corelib_source, :corelib_calls,
                  :function_calls

    def initialize(code)
      @ast = parse_js(code)

      @corelib = @ast.value.find do |i|
        es = i.to_ecma
        if es.start_with?("(function(undefined) {\n  var global_object") &&
           es.end_with?(").call(this);")
          @opal_version = 1.0
        elsif es.start_with?("(function(global_object) {\n  \"use strict\";\n"+
                             "  var console;\n  if(typeof (globalThis) !== "+
                             "'undefined') {\n") &&
              es.end_with?(").call(this);")
          @opal_version = 1.1
        end
      end

      @corelib_source = @corelib.value.value.value.value.function_body.value if @corelib

      reload
    end

    def reload
      @function_calls = ast.pointcut(FunctionCallNode).matches
      @corelib_calls = @function_calls.select do |i|
        i.value_path?(DotAccessorNode, ResolveNode, "Opal")
      end.group_by { |i| i.value.accessor }
      @corelib_calls = Hash.new { [] }.merge(@corelib_calls)
    end

    def optimize
      Step::TreeShaking.new(self).run
      Step::CollapseStubs.new(self).run

      @ast.to_ecma
    end
  end
end

require "opal/optimizer/step"
