require_relative "spec_helper"

RSpec.describe OutputToText do
  let(:test_class) { Class.new { include OutputToText }.new }
  filepath = "./insight_testsuite/tests/spec/output/repeat_donors.txt"

  before(:all) do
    File.open(filepath, 'w') {|file| file.truncate(0) }
  end

  describe "#text_writer" do
    context "if given hash and filepath" do
      it "should create text file with select hash values delimited by pipes" do
        data1 = {
          CMTE_ID: "C00384516",
          ZIP_CODE: "02895",
          YEAR: "2018",
          PERCENTILE: "333",
          SUM: 333,
          REPEATS: 1,
          DONATIONS: [333]
        }
        data2 = {
          CMTE_ID: "C00384516",
          ZIP_CODE: "02895",
          YEAR: "2018",
          PERCENTILE: 333,
          SUM: 717,
          REPEATS: 2,
          DONATIONS: [333, 384]
        }

        test_class.text_writer(data1, filepath)
        test_class.text_writer(data2, filepath)

        f = File.open(filepath, 'r')
        lines = f.readlines

        expect(lines[0]).to eq "C00384516|02895|2018|333|333|1\n"
        expect(lines[1]).to eq "C00384516|02895|2018|333|717|2\n"
      end
    end
  end
end
