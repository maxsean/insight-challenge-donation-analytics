require_relative "find_repeat_donors"
require_relative "transaction_calculator"
require_relative "output_to_text"

module FindRecipients
  include FindRepeatDonors
  include TransactionCalculator
  include OutputToText

  def gather_recipient_data(itcont_path, percentile_path, output_path)
    start = Time.now
    recipient_data = {}
    donors = find_unique_donors(itcont_path)
    repeats = find_repeat_donors(donors)

    repeats.each do |k, v|
      donations = find_latest_donations(v)
      donations.each do |donation|
        recipient = donation[:CMTE_ID]
        date = donation[:TRANSACTION_DT][4..-1]
        zip = donation[:ZIP_CODE][0..4]
        key = recipient + '|' + zip + '|' + date

        if recipient_data[key]
          begin
            recipient_data[key] = update_recipient(recipient_data[key], donation, percentile_path)
          rescue RuntimeError
            raise RuntimeError, "Error occurred, unable to finish. Please check percentile.txt input!"
          else
            text_writer(recipient_data[key], output_path)
          end

        else
          recipient_data[key] = new_recipient(donation)
          text_writer(recipient_data[key], output_path)
        end
      end
    end
    puts "finished in #{Time.now - start} secs"
  end

  def find_latest_donations(arr)
    max = 0
    sum = 0
    recipients = nil
    arr.each do |k|
      date = k[:TRANSACTION_DT]
      year = date[4..-1].to_i

      if year > max
        max = year
      end
    end

    recipients = arr.select { |k| k[:TRANSACTION_DT][4..-1].to_i == max }
  end

  def new_recipient(donation)
    output = {
      CMTE_ID: donation[:CMTE_ID],
      ZIP_CODE: donation[:ZIP_CODE][0..4],
      YEAR: donation[:TRANSACTION_DT][4..-1],
      PERCENTILE: donation[:TRANSACTION_AMT].to_i.round,
      SUM: donation[:TRANSACTION_AMT].to_i,
      REPEATS: 1,
      DONATIONS: [
        donation[:TRANSACTION_AMT].to_i
      ]
    }
  end

  def update_recipient(data, donation, percentile_path)
    data[:REPEATS] += 1
    data[:SUM] += donation[:TRANSACTION_AMT].to_i.round
    data[:DONATIONS].push(donation[:TRANSACTION_AMT].to_i.round)
    data[:DONATIONS].sort!

    begin
      percentile = get_percentile(percentile_path)
    rescue RuntimeError
      raise RuntimeError, "Error with percentile input, make sure it is a single line with a single number."
    else
      rank = ordinal_rank(percentile, data[:DONATIONS])
      data[:PERCENTILE] = data[:DONATIONS][rank - 1]

      data
    end
  end
end
