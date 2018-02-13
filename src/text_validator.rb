module TextValidator
  def record_valid?(array)
    if [array[0], array[7], array[10], array[13], array[14]].any? { |f| f == ""} || !array[14].match(/\A[+-]?\d+?(\.\d+)?\Z/) || !transaction_dt_valid?(array[13]) || !zip_code_valid?(array[10]) || !name_valid?(array[7]) || array[15] != ""
      return false
    end
    return true
  end

  def transaction_dt_valid?(date)
    month = date[0..1].to_i
    day = date[2..3].to_i
    year = date[4..-1].to_i

    return false if !date.match(/\A[+-]?\d+?(\.\d+)?\Z/)
    return false if date.length != 8
    return false if month > 12 || month < 1
    return false if day > 31 || day < 1
    return false if year < 1932 || year > Time.now.to_s[0..3].to_i
    return true
  end

  def zip_code_valid?(zipcode)
    zipcode.length < 5 ? false : true
  end

  def name_valid?(name)
    valids = ("a".."z").to_a + ("A".."Z").to_a + [",", " "]
    name.split("").any? { |c| !valids.include?(c) } ? false : true
  end
end
