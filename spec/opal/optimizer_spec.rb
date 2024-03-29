require "opal-browser"
require "opal/builder"
require "fileutils"

RSpec.describe Opal::Optimizer do
  it "optimizes a basic Opal output" do
    file = Opal::Builder.new.build_str(<<~RUBY, '(opt)').to_s
      require "opal"
    RUBY
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal + opal-browser large output" do
    file = Opal::Builder.new.build_str(<<~RUBY, '(opt)').to_s
      require "opal"
      require "native"
      require "promise"
      require "browser/setup/large"
    RUBY
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal + opal-browser traditional output" do
    file = Opal::Builder.new.build_str(<<~RUBY, '(opt)').to_s
      require "opal"
      require "native"
      require "promise"
      require "browser"
    RUBY
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes an Opal program and allows us to execute it" do
    file = Opal::Builder.new.build_str(<<~RUBY, '(opt)').to_s
      require "opal"
      o = Object.new
      def o.method_missing(meth)
        meth
      end
      puts 5.times.to_a.join
      puts o.hello
    RUBY
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
    FileUtils.mkdir_p("tmp")
    File.write("tmp/example.js", out)
    expect(`node tmp/example.js 2>#{Gem.win_platform? ? "NUL" : "/dev/null"}`).to eq("01234\nhello\n")
  end

  # Too large for now, maybe later.
  #
  #it "optimizes a basic Opal 1.1-pre + parser output" do
  #  file = File.read('spec/fixtures/opal-1.1-pre+parser-output.js')
  #  out = Opal::Optimizer.new(file).optimize
  #  expect(out).not_to be nil
  #  expect(out).to include "/* destroyed: "
  #end
end
