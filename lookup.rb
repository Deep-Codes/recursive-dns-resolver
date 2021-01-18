def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# ! Code here

# PARSE_DNS FUNCTION
def parse_dns(raw)
  # Filtering Lines with Comments and Empty Lines
  dns_filter = raw.select { |x| x[0] != "#" && x != "\n" }.map {|x| x.split(", ")}

  # Building the Hash
   dns_hash = {}
   dns_filter.each do |x| 
     dns_hash[x[1]] = {
       :type => x[0],
       :target => x[2]
     }
   end
 
   dns_hash
end

def resolve(records, chain, dom)
  record = records[dom]
  if (!record)
    chain.push("Error: Record not found for "+dom)
  elsif record[:type] == "CNAME"
    temp_domain = record[:target].strip
    chain.push(temp_domain)
    resolve(records , chain , temp_domain)
  elsif record[:type] == "A"
    chain.push(record[:target].strip)
  else
    chain.push("Invalid record type for "+dom)
  end
end

# ! Code Ends

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
