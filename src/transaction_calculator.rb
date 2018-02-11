module TransactionCalculator
  def get_percentile(filepath)
    f = File.open(filepath, "r")
    lines = f.readlines
    if lines.size == 1
      output = lines.map {|x| x[/\d+/]}.first.to_i
    else
      puts "make sure percentile.txt has one row with a single number"
    end
    output
  end

  def ordinal_rank(percentile, array)
    output = (array.size.to_f * percentile.to_f / 100).round

    output == 0 ? 1 : output
  end
end
