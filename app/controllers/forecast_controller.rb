require 'open-uri'

class ForecastController < ApplicationController
  def coords_to_weather_form
    # Nothing to do here.
    render("forecast/coords_to_weather_form.html.erb")
  end

  def coords_to_weather
    @lat = params[:user_latitude]
    @lng = params[:user_longitude]

   dark_sky_base_url = "https://api.darksky.net/forecast/94d35dfb00b4758d878609681c92ea32/"
   weather_url = dark_sky_base_url + @lat + "," + @lng
   raw_data = open(weather_url).read
   parsed_data = JSON.parse(raw_data)
   


    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data.dig("minutely", "summary")

    @summary_of_next_several_hours = parsed_data.dig("hourly", "summary")

    @summary_of_next_several_days = parsed_data.dig("daily", "summary")

    render("forecast/coords_to_weather.html.erb")
  end
end
