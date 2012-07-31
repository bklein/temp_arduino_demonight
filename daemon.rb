#!/usr/bin/ruby

require 'serialport'
require 'net/http'
require 'uri'

# values to come from command arguments
url = "http://localhost:4567"
port_str = '/dev/ttyACM0'
#

token = "qwerty6969"

baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE
 
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
 
data = ""
#just read forever
while true do
	data = sp.read
	sleep 1
	if data
		lines = data.split("\n")
		lines.each do |line|
			humidity = line.split("\t").first
			temp = line.split("\t").last
			postData = Net::HTTP.post_form(URI.parse(url),{
				'temp' => temp,
				'humidity' => humidity,
				'token' => token})
		
			puts postData.body	
			
		end
	end
end
