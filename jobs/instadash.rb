require 'instagram'
 
# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = '5ff9a1a002f041d9b49f2dbaa559fba5'
end
 
# Latitude, Longitude for location
instadash_location_lat = '45.429522'
instadash_location_long = '-75.689613'
 
SCHEDULER.every '10m', :first_in => 0 do |job|
  photos = Instagram.media_search(instadash_location_lat,instadash_location_long)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.low_resolution.url}" }
    end    
  end
  send_event('instadash', photos: photos)
end