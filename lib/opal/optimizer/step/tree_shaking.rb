require "set"

module Opal; class Optimizer; class Step

class TreeShaking < Step
  def shake_methods
    aliases = corelib_calls["alias"].map do |i|
      old = i.arguments.value[2]
      [i, "$"+old.value[1..-2]] if StringNode === old
    end.compact.to_h

    method_defs = corelib_calls["def"] +
                  corelib_calls["defs"] +
                  corelib_calls["defn"] +
                  corelib_calls["udef"] +
                  aliases.keys

    method_calls = Set.new

    method_calls += ( function_calls + exports.function_calls ).map do |i|
      out = if i.value_path?(DotAccessorNode) && i.value.accessor.start_with?("$")
        i.value.accessor
      elsif i.value_path?(BracketAccessorNode) &&
            StringNode === i.value.accessor &&
            i.value.accessor.value[1] == '$'
        i.value.accessor.value[1..-2]
      elsif i.value_path?(ResolveNode, ->(i) { %w[$send $send2 $refined_send].include? i })
        if i.value.value == '$send'
          old = i.arguments.value[1]
        else
          old = i.arguments.value[2]
        end
        "$" + old.value[1..-2] if StringNode === old
      end

      out = [out]

      case out.first
      when /\A\$(public_|private_|protected_)?(class_|instance_|singleton_)?(send|method(_defined\?)?)\z/,
           '$__send__'

        old = i.arguments.value[0]
        out << "$" + old.value[1..-2] if StringNode === old
      end

      out
    end.flatten.compact

    method_calls += aliases.values

    # Protected methods
    method_calls += []

    removed = Set.new

    method_defs.each do |m|
      name = m.arguments.value[1]
      case name
      when AddNode
        if StringNode === name.left && StringNode === name.value
          name = name.left.value[1..-2] + name.value.value[1..-2]
        else
          next
        end
      when StringNode
        name = name.value[1..-2]
        case m.value
        when ResolveNode
          name = "$" + name if m.value.value == "$alias"
        when DotAccessorNode
          name = "$" + name if m.value.accessor == "alias"
        end
      else
        next
      end

      next if method_calls.include? name

      removed << name
      m.destroy! "TreeShaking#shake_methods/#{name}"
    end

    corelib_calls["add_stubs"].each do |stubcall|
      if opal_version >= 1.4
        stubs = stubcall.arguments.value.first.value
        new_stubs = stubs[1..-2].split(",").reject do |i|
          removed.include? i[1..-1]
        end.join(',')
        new_stubs = "'#{new_stubs}'"
        stubs.replace(new_stubs)
      else
        stubcall.arguments.value.first.value.reject! do |i|
          removed.include? i.value.value[1..-2]
        end
      end
    end

    removed
  end

  def run
    loop do
      removed = shake_methods
      # $stdout.puts removed.inspect
      reload
      break if removed.length == 0
    end
  end
end

end; end; end
