RSpec.describe Opal::Optimizer do
  it "optimizes an empty string" do
    out = Opal::Optimizer.new("").optimize
    expect(out).not_to be nil
  end

  it "optimizes a basic Opal 1.0.3 output" do
    file = File.read('spec/fixtures/opal-1.0.3-output.js')
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal 1.1-pre output" do
    file = File.read('spec/fixtures/opal-1.1-pre-output.js')
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal 1.1-pre + opal-browser large output" do
    file = File.read('spec/fixtures/opal-1.1-pre+browser-large-output.js')
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal 1.1-pre + opal-browser traditional output" do
    file = File.read('spec/fixtures/opal-1.1-pre+browser-traditional-output.js')
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end

  it "optimizes a basic Opal 1.1-pre + parser output" do
    file = File.read('spec/fixtures/opal-1.1-pre+parser-output.js')
    out = Opal::Optimizer.new(file).optimize
    expect(out).not_to be nil
    expect(out).to include "/* destroyed: "
  end
end
