#!/usr/bin/ruby

# fake.rb
# fakes data

require 'net/http'
require 'uri'

url = 'http://localhost:4567'

30.times do |n|
	
	humidity = (0..100).to_a.sample
	temp = (0..100).to_a.sample
	token = "qwerty6969"
	
	postData = Net::HTTP.post_form(URI.parse(url),{
		'temp' => temp,
		'humidity' => humidity,
		'token' => token})
		
	puts postData.body	
	
	
end


