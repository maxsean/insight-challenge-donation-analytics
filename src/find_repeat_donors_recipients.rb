require_relative "find_repeat_donors"
require_relative "transaction_calculator"
require_relative "output_to_text"

module FindRecipients
  include FindRepeatDonors
  include TransactionCalculator
  include OutputToText

  def gather_recipient_data(filepath)
    start = Time.now
    output = {}
    donors = find_unique_donors(filepath + "input/itcont.txt")
    repeats = find_repeat_donors(donors)
    repeats.each do |k, v|
      donation = find_latest_donation(v)
      recipient = donation[:CMTE_ID]
      date = donation[:TRANSACTION_DT][4..-1]
      zip = donation[:ZIP_CODE]
      key = recipient + '|' + zip + '|' + date

      if output[key]
        begin
          output[key] = update_recipient(output[key], donation, filepath)
        rescue RuntimeError
          raise RuntimeError, "Error occurred, unable to finish. Please check percentile.txt input!"
        else
          text_writer(output[key], filepath)
        end

      else
        output[key] = new_recipient(donation)
        text_writer(output[key], filepath)
      end
    end
    puts "finished in #{Time.now - start} secs"
  end

  def find_latest_donation(arr)
    max = 0
    recipient = nil
    arr.each do |k|
      date = k[:TRANSACTION_DT]
      year = date[4..-1].to_i
      day = date[2..3].to_i
      month = date[0..1].to_i

      sum = year*365 + day + month*30
      if sum > max
        max = sum
        recipient = k
      end
    end
    recipient
  end

  def new_recipient(donation)
    output = {
      CMTE_ID: donation[:CMTE_ID],
      ZIP_CODE: donation[:ZIP_CODE],
      YEAR: donation[:TRANSACTION_DT][4..-1],
      PERCENTILE: donation[:TRANSACTION_AMT],
      SUM: donation[:TRANSACTION_AMT].to_i,
      REPEATS: 1,
      DONATIONS: [
        donation[:TRANSACTION_AMT]
      ]
    }
  end

  def update_recipient(data, donation, filepath)
    data[:REPEATS] += 1
    data[:SUM] += donation[:TRANSACTION_AMT].to_i
    data[:DONATIONS].push(donation[:TRANSACTION_AMT])

    begin
      percentile = get_percentile(filepath + "input/percentile.txt")
    rescue RuntimeError
      raise RuntimeError, "Error with percentile.txt input, make sure it is a single line with a single number."
    else
      rank = ordinal_rank(percentile, data[:DONATIONS])

      data[:PERCENTILE] = data[:DONATIONS][rank - 1]

      data
    end
  end
end
