# NASA Near Earth Object API Wrapper

Gives details on the closest Near Earth Objects of the day. All Near Earth Objects can now be individually selected. Currently the NEO API only holds data from 1900 to 2200, any requests for information outside these years will return nil. Data is also limited to encounters with reasonably low uncertainty.

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


#### Create client

Set the API key (only needs to be done if you want to use your own API key, default setting is DEMO_KEY)

```
client = NasaNeo::CloseObj.configure
```


#### Set the API key
The default setting is DEMO_KEY. This only needs to be set if you want to use your own API key.
```
client.key = "MyKey"
```
or suggest using an environment variable eg.
```
client.key = ENV["NASA_API_KEY"]
```

#### Change the date
Default setting is the current day, only needs to be set if you want another day. Format: YYYY-MM-DD)
```
client.date = "2019-04-10"
```

#### Update API data stored
OPTIONAL: The Near Earth Object data for the date can be called and stored before any methods are run (otherwise the first information request method will make an API call and store the data)
```
client.update
```

Please Note: If the date or key is changed the next method requesting information will make an API call. You can use `update` (as above) to store the data in anticipation of running the methods beforehand if needed but is not necessary. Only one API call is made unless there are changes to the date, API key or `update` is run again.


### Retrieving Information

#### General

##### Find the number of API calls remaining using current key
```
client.calls_remaining
```
Example return:
```
29
```
Note: If an API call has not been made yet then an error hash is returned (`{:error=>"make new API call first"}`) as the calls remaining data is returned in the header of the API call. If an API key is changed then again an API call will need to be made first to retrieve this information.

##### Find the total Near Earth Objects recorded for the date

```
client.neo_total
```
Example return:
```
10
```

##### Select Near Earth Object
Manually select a Near Earth Object for the date (if not a recognised number all data returned when methods are executed will be `nil`). Note: The initial set default is the first (closest).

Example(selects 2nd closest Near Earth Object):
```
client.neo_select(2)
```

#### Current Selected Near Earth Object

##### Given name

```
client.neo_name
```
Example return:
```
"(2004 VB)"
```


##### Potential hazardousness boolean
Based on potential future Earth impact
```
client.hazardous?
```
Example return:
```
false
```

##### Estimated diameter

```
client.estimated_diameter
```
Example return:
```
{"kilometers"=>{"estimated_diameter_min"=>0.1838886721, "estimated_diameter_max"=>0.411187571}, "meters"=>{"estimated_diameter_min"=>183.8886720703, "estimated_diameter_max"=>411.1875710413}, "miles"=>{"estimated_diameter_min"=>0.1142630881, "estimated_diameter_max"=>0.2555000322}, "feet"=>{"estimated_diameter_min"=>603.309310875, "estimated_diameter_max"=>1349.040630575}}
```
---
Current valid arguments: "kilometers", "meters", "miles", "feet"
```
client.estimated_diameter("meters")
```
Example return:
```
{"estimated_diameter_min"=>183.8886720703, "estimated_diameter_max"=>411.1875710413}
```
---
Current valid arguments: "min", "max"
```
client.estimated_diameter("meters", "min")
```
Example return:
```
183.8886720703
```

##### Miss distance to earth

```
client.miss_distance
```
Example return:
```
{"astronomical"=>"0.1915058335", "lunar"=>"74.4957733154", "kilometers"=>"28648866", "miles"=>"17801580"}
```
---
Current valid arguments: "astronomical", "lunar", "kilometers", "miles"
```
client.miss_distance("miles")
```
Example return (converts string to float):
```
17801580
```


##### Velocity

```
client.velocity
```
Example return:
```
{"kilometers_per_second"=>"14.488889894", "kilometers_per_hour"=>"52160.0036184644", "miles_per_hour"=>"32410.1978039286"}
```
---
Current valid arguments: "kilometers_per_second", "kilometers_per_hour", "miles_per_hour"
```
client.velocity("miles_per_hour")
```
Example return (converts string to float)
```
32410.1978039286
```


##### Raw data of Near Earth Object based on date

```
client.neo_data
```

Example return (all raw data on closest object):
```
{"links"=>{"self"=>"https://api.nasa.gov/neo/rest/v1/neo/3840869?api_key=DEMO_KEY"}, "id"=>"3840869", "neo_reference_id"=>"3840869", "name"=>"(2019 GK4)", "nasa_jpl_url"=>"http://ssd.jpl.nasa.gov/sbdb.cgi?sstr=3840869", "absolute_magnitude_h"=>23.83, "estimated_diameter"=>{"kilometers"=>{"estimated_diameter_min"=>0.0455569852, "estimated_diameter_max"=>0.1018685158}, "meters"=>{"estimated_diameter_min"=>45.5569852336, "estimated_diameter_max"=>101.8685158322}, "miles"=>{"estimated_diameter_min"=>0.0283077895, "estimated_diameter_max"=>0.0632981416}, "feet"=>{"estimated_diameter_min"=>149.4651794337, "estimated_diameter_max"=>334.214301483}}, "is_potentially_hazardous_asteroid"=>false, "close_approach_data"=>[{"close_approach_date"=>"2019-04-10", "epoch_date_close_approach"=>1554879600000, "relative_velocity"=>{"kilometers_per_second"=>"14.9701946153", "kilometers_per_hour"=>"53892.7006150984", "miles_per_hour"=>"33486.828334976"}, "miss_distance"=>{"astronomical"=>"0.089370038", "lunar"=>"34.7649421692", "kilometers"=>"13369567", "miles"=>"8307464"}, "orbiting_body"=>"Earth"}], "is_sentry_object"=>false}
```

##### All raw data held on selected Near Earth Object
```
client.neo_data_verbose
```

Returns all data held on the Near Earth Object. Includes all data on the dates of closest miss distances to Earth.

Note: This will initially make an addition API call to retrieve this information, but like the first API call will not make additional calls unless the selected Near Earth Object is changed.

### Exceptions

Exceptions are returned as a hash

Example of wrong API key set:
```
client.key = "wrong API key"
```
Returns (on next API call method):
```
{:error=>["400", "Forbidden"]}
```
If a status error is returned the next method request for information will make an API call

---
Example of unrecognised argument on method:
```
client.estimated_diameter("wrong measurement unit")
```
Returns:
```
{:error=>["measurement", "check argument"]}
```
---
Example of return if information no present, eg. if selected number of Near Earth Object is not present:
```
client.neo_select(99)
client.neo_name
```
Returns:
```
nil
```
---
Example of return if any information not present (would return nil for any of the methods attempting to retrieve information). It would most likely mean that it's outside the year range.
```
client.date = "2400-01-01"
client.miss_distance("miles")
```
Returns:
```
nil
```
---
Example of return if method requesting the number of API calls left using the current key is made before any API calls are made.
```
client.calls_remaining
```
Returns:
```
{:error>=>"make new API call first"}
```


### Testing

Uses `RSpec 3.8`

Run tests:
`bundle exec rspec`
