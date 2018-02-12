require_relative "spec_helper"

RSpec.describe FindRepeatDonors do
  let(:test_class) { Class.new { include FindRepeatDonors }.new }
  filepath = "./insight_testsuite/tests/spec/input/"

  describe "#find_unique_donors" do
    context "if filepath is valid" do
      it "should return a hash of unique donors" do
        unique_donors = test_class.find_unique_donors(filepath + "itcont.txt")

        expect(unique_donors).to be_kind_of Hash
        expect(unique_donors.size).to be 4

        unique_donors.each do |key, value|
          expect(value).to be_kind_of Array
          expect(value.size).not_to eq 0
          expect(value.first).to be_kind_of Hash
          expect(value.first.size).to eq 5

          value.first.each do |k, v|
            expect(v).to be_kind_of String
          end
        end
      end
    end
  end

  describe "#itcont_reduced" do
    context "if given array with valid itcont FEC positions" do
      it "should return a hash with donation data" do
        arr = [
          "C00177436",
          "N",
          "M2",
          "P",
          "201702039042410894",
          "15",
          "IND",
          "DEEHAN, WILLIAM N",
          "ALPHARETTA",
          "GA",
          "300047357",
          "UNUM",
          "SVP, SALES, CL",
          "01312017",
          "384",
          "",
          "PR2283873845050",
          "1147350",
          "",
          "P/R DEDUCTION ($192.00 BI-WEEKLY)",
          "4020820171370029337\n"
        ]
        itcont = test_class.itcont_reduced(arr)

        expect(itcont).to be_kind_of Hash
        expect(itcont.size).to eq 5

        itcont.each do |k, v|
          expect(v).to be_kind_of String
        end
      end
    end
  end

  describe "#find_repeat_donors" do
    context "if input is a hash of arrays" do
      it "should return a hash of arrays with sizes greater than one" do
        unique_donors = test_class.find_unique_donors(filepath + "itcont.txt")

        repeats = test_class.find_repeat_donors(unique_donors)

        expect(repeats).to be_kind_of Hash
        repeats.each do |k, v|
          expect(v).to be_kind_of Array
          expect(v.size).not_to eq 1
          expect(v.size).not_to eq 0
        end
      end
    end
  end
end
