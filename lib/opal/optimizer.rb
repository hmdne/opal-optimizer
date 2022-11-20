require "opal/optimizer/version"
require "rkelly"
require "opal/optimizer/helpers"
require "opal/compiler"

require "pry"

module Opal
  class Optimizer
    include Helpers

    attr_accessor :ast, :opal_version, :corelib, :corelib_source, :corelib_calls,
                  :function_calls

    attr_accessor :exports

    def initialize(code, exports: "", force_corelib: true)
      @ast = parse_js(code)

      @corelib = @ast.value.find do |i|
        es = code[i.range.from.index..i.range.to.index]
        if es.start_with?("(function(undefined) {\n  // @note\n"\
                          "  //   A few conventions for the documentation of this file:") &&
           es.end_with?("TypeError.$$super = Error;\n}).call(this);")
          @opal_version = 1.0
        elsif es.start_with?("(function(global_object) {\n  \"use strict\";\n\n  // @note\n  "\
                             "//   A few conventions for the documentation of this file:")
          if es.end_with?("TypeError.$$super = Error;\n}).call(this);")
            if es.include? 'function $prop(object,'
              @opal_version = 1.4
            else
              @opal_version = 1.1
            end
          elsif es.end_with?("Opal.file_sources = {};\n}).call(this);")
            @opal_version = 1.6
          end
        end
      end

      raise ArgumentError, "Couldn't deduce Opal version based on this content" if force_corelib && !@corelib

      @corelib_source = @corelib.value.value.value.value.function_body.value if @corelib

      reload

      # Are exports js or do we need to compile them first?
      unless [nil, ""].include?(exports) || exports.start_with?("(function(")
        exports = Opal::Compiler.new(exports).compile
      end
      @exports = Opal::Optimizer.new(exports, exports: nil, force_corelib: false) unless exports == nil
    end

    def reload
      @function_calls = ast.pointcut(FunctionCallNode).matches
      @corelib_calls = @function_calls.select do |i|
        i.value_path?(DotAccessorNode, ResolveNode, "Opal") ||
        i.value_path?(ResolveNode, /\A\$/)
      end.group_by { |i| (i.value.value.is_a?(String) ? i.value.value : i.value.accessor).gsub('$', '') }
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
