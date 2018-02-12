module TransactionCalculator
  def get_percentile(filepath)
    f = File.open(filepath, "r")
    lines = f.readlines
    if lines.size == 1
      output = lines.map {|x| x[/\d+/]}.first.to_i
      if (1..100).include?(output)
        return output
      else
        raise RuntimeError, "Please make sure percentile is between 1-100."
      end
    else
      raise RuntimeError, "Please make sure percentile.txt has a single line."
    end
  end

  def ordinal_rank(percentile, array)
    output = (array.size.to_f * percentile.to_f / 100).round

    output == 0 ? 1 : output
  end
end
