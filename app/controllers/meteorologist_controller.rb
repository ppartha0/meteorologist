require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

   ### Substitute any blank spaces with +s
   scrubbed_address = @street_address.gsub(" ","+")
   ### Now put that into the Google API
   default_api = "https://maps.googleapis.com/maps/api/geocode/json?address="
   address_api = default_api + scrubbed_address
   ### Query the resulting API to retrieve "geometry[location][lat] and [long]"  
   raw_data = open(address_api).read
   parsed_data = JSON.parse(raw_data)
   location_data = parsed_data["results"][0]["geometry"]["location"]
   lat = location_data["lat"]
   lng = location_data["lng"]
    
   dark_sky_base_url = "https://api.darksky.net/forecast/94d35dfb00b4758d878609681c92ea32/"
   weather_url = dark_sky_base_url + lat.to_s + "," + lng.to_s  
   raw_data = open(weather_url).read
   parsed_data = JSON.parse(raw_data)
  # ==========================================================================
  
  @current_temperature = parsed_data["currently"]["temperature"]

  @current_summary = parsed_data["currently"]["summary"]

  @summary_of_next_sixty_minutes = parsed_data.dig("minutely", "summary")

  @summary_of_next_several_hours = parsed_data.dig("hourly", "summary")

  @summary_of_next_several_days = parsed_data.dig("daily", "summary")


    render("meteorologist/street_to_weather.html.erb")
  end
end
