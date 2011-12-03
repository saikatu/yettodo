require 'date'

def parse(s)
  result = Hash.new
  text = String.new(s)
  
  s.scan(/\S+/) do |w|
  
    #search for context
    w.scan(/(~(\S+))/i) do |match|
      result["context"] = match[1]
      text.sub!(/\s?#{Regexp.escape(match[0])}\s?/, " ")
    end
    
    #search for 
    w.scan(/(!(\S+))/i) do |match|
      result["priority"] = match[1]
      text.sub!(/\s?#{Regexp.escape(match[0])}\s?/, " ")
    end
    
    #date_at or date_to
    begin
    w.scan(/(([\^|=|<])(tomorrow|today|([0-3]\d)[\-|\.]([01]\d)[\-|\.](\d{4})|(\d{4})[\-|\.]([01]\d)[\-|\.]([0-3]\d)|([0-3]\d)[\-|\.]([01]\d)))/i) do |match|
      date = nil
      #31-12-2012 or 31.12.2012
      if(!match[3].nil?)
        date = DateTime.new(match[5].to_i, match[4].to_i, match[3].to_i)
      #2012-12-31 or 2012.12.31
      elsif(!match[6].nil?)
        date = DateTime.new(match[6].to_i, match[7].to_i ,match[8].to_i)
      #31-12
      elsif(!match[9].nil?)
        date = DateTime.new(DateTime.now.year, match[10].to_i, match[9].to_i)
      elsif(match[2].downcase == "today")
        date = DateTime.now
      elsif(match[2].downcase == "tomorrow")
        date = DateTime.now + 1
      end
      
      if(match[1] == "<")#date_to
        result["date_to"] = date
      else #date_at
        result["date_at"] = date
      end
      
      text.sub!(/\s?#{Regexp.escape(match[0])}\s?/, " ")
    end
    rescue
    end

  end
  
  result["text"] = text.strip
  return result
end

print parse("123 ~456 =31.12.2011 <12.12 789 ~adc")
