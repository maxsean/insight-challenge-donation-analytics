require_relative "spec_helper"

RSpec.describe TextValidator do
  let(:test_class) { (Class.new { include TextValidator }).new }

  input = [
    "C00629688",
    "N",
    "TER",
    "P",
    "201701230300133512",
    "15C",
    "IND",
    "SMITH, JOHN C",
    "LOS ANGELES",
    "CA",
    "90017",
    "PRINCIPAL",
    "SOME COMPANY",
    "01032017",
    "40",
    "",
    "SA01251735122",
    "1141239",
    "",
    "",
    "2012520171368850783\n"
  ]


  describe '#record_valid?' do
    context 'if CMTE_ID, NAME, ZIP_CODE, TRANSACTION_DT, or TRANSACTION_AMT fields are empty' do
      it 'returns false' do
        input[0] = ""
        expect(test_class.record_valid?(input)).to eq false
        input[0] = "C00629688"
        input[7] = ""
        expect(test_class.record_valid?(input)).to eq false
        input[7] = "SMITH, JOHN C"
        input[10] = ""
        expect(test_class.record_valid?(input)).to eq false
        input[10] = "90017"
        input[13] = ""
        expect(test_class.record_valid?(input)).to eq false
        input[13] = "01032017"
        input[14] = ""
        expect(test_class.record_valid?(input)).to eq false
        input[14] = "40"
      end
    end

    context 'if OTHER_UD is not empty' do
      it 'returns false' do
        input[15] = "SOMEID"
        expect(test_class.record_valid?(input)).to eq false
        input[15] = ""
      end
    end

    context 'if data is valid' do
      it 'returns true' do
        expect(test_class.record_valid?(input)).to eq true
      end
    end
  end

  describe '#transaction_dt_valid?' do
    context 'if date has extra or missing elements' do
      it 'returns false' do
        expect(test_class.transaction_dt_valid?("JAN241990")).to eq false

        expect(test_class.transaction_dt_valid?("241990")).to eq false
      end
    end

    context 'if month is not valid' do
      it 'returns false' do
        expect(test_class.transaction_dt_valid?("00121987")).to eq false

        expect(test_class.transaction_dt_valid?("JA121987")).to eq false

        expect(test_class.transaction_dt_valid?("31121987")).to eq false
      end
    end

    context 'if day is not valid' do
      it 'returns false' do
        expect(test_class.transaction_dt_valid?("01001987")).to eq false

        expect(test_class.transaction_dt_valid?("01321987")).to eq false

        expect(test_class.transaction_dt_valid?("01%a1987")).to eq false
      end
    end

    context 'if year is not valid' do
      it 'returns false' do
        current_year = Time.now.to_s[0..3].to_i
        expect(test_class.transaction_dt_valid?("11231231")).to eq false

        expect(test_class.transaction_dt_valid?("1123u@s1")).to eq false

        expect(test_class.transaction_dt_valid?("1121#{current_year + 1}")).to eq false
      end
    end

    context 'if date is valid' do
      it 'returns true' do
        expect(test_class.transaction_dt_valid?("11232017")).to eq true
      end
    end
  end

  describe '#zip_code_valid?' do
    context 'if zipcode is not valid' do
      it 'returns false' do
        expect(test_class.zip_code_valid?("1234")).to eq false
      end
    end

    context 'if zipcode is valid' do
      it 'returns true' do
        expect(test_class.zip_code_valid?("02111")).to eq true

        expect(test_class.zip_code_valid?("02111-1004")).to eq true
      end
    end
  end

  describe '#name_valid?' do
    context 'if name is not valid' do
      it 'returns false' do
        expect(test_class.name_valid?("12SMITH, JO")).to eq false

        expect(test_class.name_valid?("@@!!_ITH, JT")).to eq false
      end
    end
    context 'if name is valid' do
      it 'returns true' do
        expect(test_class.name_valid?("SMITH, JOHN C")).to eq true

        expect(test_class.name_valid?("SMITH, J")).to eq true

        expect(test_class.name_valid?("SMITH, ")).to eq true

        expect(test_class.name_valid?(", JOHN")).to eq true
      end
    end
  end
end
