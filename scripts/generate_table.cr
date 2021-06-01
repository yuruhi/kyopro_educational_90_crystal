require "json"

count = 1
json_text = `oj-api get-contest https://atcoder.jp/contests/typical90/`
JSON.parse(json_text)["result"]["problems"].as_a.each do |hash|
  num = count.to_s.rjust(3, '0')
  puts "| [#{num} - #{hash["name"]}](#{hash["url"]}) " \
       "| [<u>■</u>](https://github.com/yuruhi/kyopro_educational_90_crystal/blob/main/code/#{num}.cr)" \
       "| ms " \
       "| Bytes" \
       "| 想定解 |"
  count += 1
end
