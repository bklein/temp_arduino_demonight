require 'sinatra'
require 'data_mapper'
require 'time'


# a token to authenticate (loosly....)
SECRET_TOKEN = "qwerty6969"

DataMapper::setup(:default, "sqlite://#{Dir.pwd}/weather.db")

class Weather
	include DataMapper::Resource
	property :id, Serial
	property :temp, String, :required => true # in Farenheight
	property :humidity, Integer, :required => true # Relative %
	property :created_at, DateTime
	
	def timestamp
		#tstamp = Time.parse(self.created_at)
		#tstamp.strftime("%I:%M%p on %m/%d/%Y")
		self.created_at.strftime("%I:%M%p on %m/%d/%Y")
	end
	
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@weathers = Weather.all(:limit => 20, :order => [:created_at.desc])
	erb :home
end

get '/all' do
	@weathers = Weather.all(:order => [:created_at.desc])
	erb :home
end

post '/' do
	@temp = params[:temp]
	@humidity = params[:humidity]
	@token = params[:token]
	
	if @temp.nil? || @humidity.nil? || @token.nil?
		"error"
	elsif @token != SECRET_TOKEN
		"error"
	else
		# save recording
		@timestamp = Time.now
		@weather = Weather.new(
			:temp => @temp,
			:humidity => @humidity,
			:created_at => @timestamp
		)
		if @weather.save
			"ok"
		else	
			"save error"
		end
	end
end

		
