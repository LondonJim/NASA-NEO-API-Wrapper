# Nasa Near Earth Object API Wrapper

Gives details on the closest Near Earth Object of the day.

## Installation

Written using `Ruby 2.6.1`

Add this line to your application's Gemfile:

```ruby
gem 'nasa-neo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nasa-neo

## Usage

### Configuration
A default api key of DEMO_KEY will let you make up to 30 requests per hour (50 per day), if you have your own api key (https://api.nasa.gov/index.html#apply-for-an-api-key) you can set it as detailed under instructions (developer API keys allow up to 1000 requests an hour)

Create client to make requests to the API (using demo api key):

```
client = NasaNeo::CloseObj.configure
```

Set the API key (only needs to be done is you want to use your own API key, default setting is DEMO_KEY)
```
client.key = "MyKey"
```

Change the date (only needs to be done if you want to select another data, default setting is the current day)
```
client.date = "2019-04-10"
```
Please Note: The first request for information results in an API call, unless the date or API key is changed no more API calls are made as the information of the closet near earth object is stored on the first request.

### Retrieving Information

#### Given name

```
client.neo_name
```
Example return:
```
"(2004 VB)"
```


#### Potential hazardousness boolean
```
client.hazardous?
```
Example return (hopefully):
```
false
```

#### Estimated diameter

```
client.estimated_diameter
```
Example return:
```
{"kilometers"=>{"estimated_diameter_min"=>0.1838886721, "estimated_diameter_max"=>0.411187571}, "meters"=>{"estimated_diameter_min"=>183.8886720703, "estimated_diameter_max"=>411.1875710413}, "miles"=>{"estimated_diameter_min"=>0.1142630881, "estimated_diameter_max"=>0.2555000322}, "feet"=>{"estimated_diameter_min"=>603.309310875, "estimated_diameter_max"=>1349.040630575}}
```


#### Miss distance to earth

```
client.miss_distance
```
Example return:
```
{"astronomical"=>"0.1915058335", "lunar"=>"74.4957733154", "kilometers"=>"28648866", "miles"=>"17801580"}
```


#### Velocity

```
client.velocity
```
Example return:
```
{"kilometers_per_second"=>"14.488889894", "kilometers_per_hour"=>"52160.0036184644", "miles_per_hour"=>"32410.1978039286"}
```


#### All data on closest object

```
client.neo_data
```

Example return:
```
{"links"=>{"self"=>"https://api.nasa.gov/neo/rest/v1/neo/3840869?api_key=DEMO_KEY"}, "id"=>"3840869", "neo_reference_id"=>"3840869", "name"=>"(2019 GK4)", "nasa_jpl_url"=>"http://ssd.jpl.nasa.gov/sbdb.cgi?sstr=3840869", "absolute_magnitude_h"=>23.83, "estimated_diameter"=>{"kilometers"=>{"estimated_diameter_min"=>0.0455569852, "estimated_diameter_max"=>0.1018685158}, "meters"=>{"estimated_diameter_min"=>45.5569852336, "estimated_diameter_max"=>101.8685158322}, "miles"=>{"estimated_diameter_min"=>0.0283077895, "estimated_diameter_max"=>0.0632981416}, "feet"=>{"estimated_diameter_min"=>149.4651794337, "estimated_diameter_max"=>334.214301483}}, "is_potentially_hazardous_asteroid"=>false, "close_approach_data"=>[{"close_approach_date"=>"2019-04-10", "epoch_date_close_approach"=>1554879600000, "relative_velocity"=>{"kilometers_per_second"=>"14.9701946153", "kilometers_per_hour"=>"53892.7006150984", "miles_per_hour"=>"33486.828334976"}, "miss_distance"=>{"astronomical"=>"0.089370038", "lunar"=>"34.7649421692", "kilometers"=>"13369567", "miles"=>"8307464"}, "orbiting_body"=>"Earth"}], "is_sentry_object"=>false}
```

### Exceptions

Exceptions are returned as a hash (example of wrong date):
```
client.date = "123"
```
Returns:
```
{:error=>["400", ""]}
```
If an error is returned the next method request for information will make an API call


### Testing

Uses `RSpec 3.8`

Run tests:
`bundle exec rspec`
