require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'IIZifBNX4o1w3SZgfR5NmCTfx'
  config.consumer_secret = 'g5dtbcMyj7ikU20ssaEhjuLKS1FDRBZKqHgY5SnfdienJZVhUL'
  config.access_token = '31228311-diGWxeUpKs4Ou2Sd79rSyNrNWsEaAPxhL1Pn5N0OU'
  config.access_token_secret = 'Hbrlv0zigyTn2y3gHgHV7zUxpQqzxw37UR4zw4TSrYE2l'
end

search_term = URI::encode('#ohheckyeah')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end