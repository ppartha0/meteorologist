require 'open-uri'

class GeocodingController < ApplicationController
  def street_to_coords_form
    # Nothing to do here.
    render("geocoding/street_to_coords_form.html.erb")
  end

  def street_to_coords
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
    @latitude = location_data["lat"]
    @longitude = location_data["lng"]

    render("geocoding/street_to_coords.html.erb")
  end
end
