### Submission 2:

Based on the Suggestions Given:

1. more functional by using `map` and `each` for putting the data into the record

```rb
dns_filter = raw.select { |x| x[0] != "#" && x != "\n" }.map {|x| x.split(", ")}

   dns_hash = {}
   dns_filter.each do |x|
     dns_hash[x[1]] = {
       :type => x[0],
       :target => x[2]
     }
   end
```

2. Use a nested hash instead of a positional array for parsing DNS.

Previously `dns_hash` had a structure like this

```rb
dns_hash = {
    "RECORDTYPE".to_sym => record_type_list,
    "SOURCE".to_sym => source_list,
    "DESTINATION".to_sym => destination_list,
}
```

Now it's a hash where the key is the domain, and the value is another hash with :type and :target.

```rb
{
  "gmail.com" => {:type => "CNAME", :target => "mail.google.com"},
  "google.com" => {:type => "A", :target => "11.11.111"},
  ...
}
```

The `resolve` method changes to this form:

```rb
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
```
