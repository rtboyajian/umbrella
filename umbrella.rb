# Write your solution below!
require "http"
require "json"
require 'dotenv/load'
require "uri"

# Access hidden variables
gmaps_api_key = ENV.fetch("GMAPS_KEY")
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_KEY")

#request user's location
puts "Where are you located?"
user_location = gets.chomp
address = URI.encode_www_form_component(user_location)

#Assemble full URL string with API token
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{gmaps_api_key}"
#pp gmaps_url 


#place a GET requerst to the URL for user's location and coordinates
response = HTTP.get(gmaps_url)
raw_response = response.to_s
parsed = JSON.parse(raw_response)

#check JSON to see status (should be "OK" and results should be non-empty array if Google found user's place)
#pp parsed.fetch("status")
#pp parsed.fetch("results")

#grab the coordinates from Google's response
first = parsed.fetch("results").at(0)
geometry = first.fetch("geometry")
loc_hash = geometry.fetch("location")
lat = loc_hash.fetch("lat")
lng = loc_hash.fetch("lng")
coordinates = "#{lat}, #{lng}"

puts "Your coordinates are #{lat}, #{lng}."

#Use coordinates to call Pirate Weather for weather info

pirate_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{coordinates}"
weather = HTTP.get(pirate_url)
weather_parsed = JSON.parse(weather.to_s)
currently = weather_parsed.fetch("currently")
current_temp = currently.fetch("temperature")
minutely = weather_parsed.fetch("minutely")
summary = minutely.fetch("summary")

puts "It is currently #{current_temp}."
puts "Next hour: #{summary}"

if 
