require_relative "spec_helper"

RSpec.describe FindRecipients do
  let(:test_class) { Class.new { include FindRecipients }.new }

  before(:all) do
    File.open('./insight_testsuite/tests/spec/output/repeat_donors.txt', 'w') {|file| file.truncate(0) }
    File.open('./insight_testsuite/tests/spec/invalid_data/output/repeat_donors.txt', 'w') {|file| file.truncate(0) }
  end

  describe "#gather_recipient_data" do
    context "if filepath and data is valid" do
      it "should put a message to STDOUT" do
        itcont_path = "./insight_testsuite/tests/spec/input/itcont.txt"
        percentile_path = "./insight_testsuite/tests/spec/input/percentile.txt"
        output_path = "./insight_testsuite/tests/spec/output/repeat_donors.txt"

        expect { test_class.gather_recipient_data(itcont_path, percentile_path, output_path) }.to output(/finished/).to_stdout

      end
      it "should generate text file with recipient data" do
        output_path = "./insight_testsuite/tests/spec/output/repeat_donors.txt"
        f = File.open(output_path)
        lines = f.readlines

        expect(lines[0]).to eq "C00384516|02895|2018|333|333|1\n"
        expect(lines[1]).to eq "C00384516|02895|2018|333|717|2\n"
      end
    end

    context "if data is not valid" do
      it "should raise an error" do
        itcont_path = "./insight_testsuite/tests/spec/invalid_data/input/itcont.txt"
        percentile_path = "./insight_testsuite/tests/spec/invalid_data/input/percentile.txt"
        output_path = "./insight_testsuite/tests/spec/invalid_data/output/repeat_donors.txt"

        expect { test_class.gather_recipient_data(itcont_path, percentile_path, output_path) }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#find_latest_donations" do
    context "if given valid repeat donor's array of donations" do
      it "should return latest donations" do
        arr = [
          {:CMTE_ID=>"C00384818",
          :NAME=>"ABBOTT, JOSEPH",
          :ZIP_CODE=>"02895",
          :TRANSACTION_DT=>"01122017",
          :TRANSACTION_AMT=>"250"},
          {:CMTE_ID=>"C00384516",
          :NAME=>"ABBOTT, JOSEPH",
          :ZIP_CODE=>"02895",
          :TRANSACTION_DT=>"01122018",
          :TRANSACTION_AMT=>"333"}
        ]
        latest = test_class.find_latest_donations(arr)

        expect(latest).to be_kind_of Array
        expect(latest.first.size).to eq 5
        expect(latest.first).to eq({
          CMTE_ID: "C00384516",
          NAME: "ABBOTT, JOSEPH",
          ZIP_CODE: "02895",
          TRANSACTION_DT: "01122018",
          TRANSACTION_AMT: "333"
        })
      end
    end
  end

  describe "#new_recipient" do
    context "if given valid repeat donor's donation" do
      it "should return recipient data" do
        donation = {
          CMTE_ID: "C00384516",
          NAME: "ABBOTT, JOSEPH",
          ZIP_CODE: "02895",
          TRANSACTION_DT: "01122018",
          TRANSACTION_AMT: "333"
        }
        recipient = test_class.new_recipient(donation)

        expect(recipient).to be_kind_of Hash
        expect(recipient.size).to eq 7
        expect(recipient).to eq({
          CMTE_ID: "C00384516",
          ZIP_CODE: "02895",
          YEAR: "2018",
          PERCENTILE: 333,
          SUM: 333,
          REPEATS: 1,
          DONATIONS: [333]
        })
      end
    end
  end

  describe "#update_recipient" do
    context "if given recipient data, new donation, and valid filepath to percentile.txt" do
      it "should return updated recipient data" do
        original = {
          CMTE_ID: "C00384516",
          ZIP_CODE: "02895",
          YEAR: "2018",
          PERCENTILE: 333,
          SUM: 333,
          REPEATS: 1,
          DONATIONS: [333]
        }
        new_donation = {
          CMTE_ID: "C00384516",
          NAME: "SABOURIN, JAMES",
          ZIP_CODE: "02895",
          TRANSACTION_DT: "01312018",
          TRANSACTION_AMT: "384"
        }
        percentile_path = "./insight_testsuite/tests/spec/input/percentile.txt"

        updated = test_class.update_recipient(original, new_donation, percentile_path)

        expect(updated).to be_kind_of Hash
        expect(updated.size).to eq 7
        expect(updated).to eq({
          CMTE_ID: "C00384516",
          ZIP_CODE: "02895",
          YEAR: "2018",
          PERCENTILE: 333,
          SUM: 717,
          REPEATS: 2,
          DONATIONS: [333, 384]
        })
      end
    end
  end
end
