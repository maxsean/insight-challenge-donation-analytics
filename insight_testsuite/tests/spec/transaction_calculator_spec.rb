require_relative "spec_helper"

RSpec.describe TransactionCalculator do
  let(:test_class) { (Class.new { include TransactionCalculator }).new }

  describe "#get_percentile" do
    context "if input is not valid" do
      it "should raise an error" do
        filepath = "./insight_testsuite/tests/spec/invalid_data/"

        expect { test_class.get_percentile(filepath + "input/percentile.txt") }.to raise_error(RuntimeError)

        expect { test_class.get_percentile(filepath + "input/percentile2.txt") }.to raise_error(RuntimeError)
      end
    end

    context "if input is valid" do
      it "should return percentile" do
        filepath = "./insight_testsuite/tests/spec/"
        expect(test_class.get_percentile(filepath + "input/percentile.txt")).to eq 30
      end
    end
  end

  describe "#ordinal_rank" do
    context "if input is valid" do
      it "should return a rounded ordinal rank" do
        arr = [15, 20, 35, 40, 50]
        expect(test_class.ordinal_rank(5, arr)).to eq 1

        expect(test_class.ordinal_rank(30, arr)).to eq 2

        expect(test_class.ordinal_rank(40, arr)).to eq 2

        expect(test_class.ordinal_rank(50, arr)).to eq 3

        expect(test_class.ordinal_rank(100, arr)).to eq 5
      end
    end
  end
end
