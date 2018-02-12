require_relative "text_validator"

module FindRepeatDonors
  include TextValidator

  def find_unique_donors(filepath)
    f = File.open(filepath, "r")
    unique_donors = {}
    lines = f.readlines

    lines.each do |line|
      line_array = line.split('|')
      if record_valid?(line_array)
        red_rec = itcont_reduced(line_array)

        unique = line_array[7] + line_array[10]

        unique_donors[unique] ? unique_donors[unique].push(red_rec) : unique_donors[unique] = [red_rec]
      end
    end
    unique_donors
  end

  def itcont_reduced(array)
    output = {
      CMTE_ID: array[0],
      NAME: array[7],
      ZIP_CODE: array[10][0..4],
      TRANSACTION_DT: array[13],
      TRANSACTION_AMT: array[14],
    }
  end

  def find_repeat_donors(donors)
    repeats = {}
    donors.select { |k,v| v.size > 1 }.each do |donor, donations|
      check = []
      donations.each { |donation| check.push(donation[:TRANSACTION_DT][4..-1]) }
      repeats[donor] = donations if check.uniq.size > 1
    end
    
    repeats
  end
end
