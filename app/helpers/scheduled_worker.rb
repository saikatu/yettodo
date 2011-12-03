require "rubygems"
require "twitter"
require './parser.rb'
require 'cgi'

def getTasks(since_id)
  result = Hash.new
  Twitter.search("to:yettodo", :since_id => since_id, :with_twitter_user_id => true ).map do |status|
    id = status.attrs["id_str"]
    result[id] = Hash.new
    result[id]["user_id"] = status.from_user_id
    result[id]["text"] = status.text
    result[id]["taskdata"] = parse(CGI.unescapeHTML(status.text), "yettodo")
  end
  
  return result

end

print getTasks(1)
