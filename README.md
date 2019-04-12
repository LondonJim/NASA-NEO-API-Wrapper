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

(only needs to be done if you want to use your own API key, default setting is DEMO_KEY)
```
client.key = "MyKey"
```

#### Change the date
(only needs to be done if you want to select another date, default setting is the current day. Format: YYYY-MM-DD)
```
client.date = "2019-04-10"
```

#### Update
OPTIONAL: The Near Earth Object data for the date can be called and stored before any methods are run (otherwise the first information request method will make an API call and store the data)
```
client.update
```

#### Select Near Earth Object
Manually select a Near Earth Object for the date (if not a recognised number all data returned will be `nil`). Note: The default is the first (closest). To find the total number of Near Earth Objects recorded for the date see `Find the total Near Earth Objects recorded for the date` in the next section.

Example(selects 2nd closest Near Earth Object):
```
client.neo_select(2)
```

Please Note: If the date or key is changed the next method requesting information will make an API call. You can use `update` (as above) to store the data in anticipation of running the methods beforehand if needed but is not necessary. Only one API call is made unless there are changes to the date, API key or `update` is run again.


### Retrieving Information

#### Find the total Near Earth Objects recorded for the date

```
client.neo_total
```
Example return:
```
10
```

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

#### Miss distance to earth

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


#### Velocity

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


#### All data on closest object selected

```
client.neo_data
```

Example return (all raw data on closest object):
```
{"links"=>{"self"=>"https://api.nasa.gov/neo/rest/v1/neo/3840869?api_key=DEMO_KEY"}, "id"=>"3840869", "neo_reference_id"=>"3840869", "name"=>"(2019 GK4)", "nasa_jpl_url"=>"http://ssd.jpl.nasa.gov/sbdb.cgi?sstr=3840869", "absolute_magnitude_h"=>23.83, "estimated_diameter"=>{"kilometers"=>{"estimated_diameter_min"=>0.0455569852, "estimated_diameter_max"=>0.1018685158}, "meters"=>{"estimated_diameter_min"=>45.5569852336, "estimated_diameter_max"=>101.8685158322}, "miles"=>{"estimated_diameter_min"=>0.0283077895, "estimated_diameter_max"=>0.0632981416}, "feet"=>{"estimated_diameter_min"=>149.4651794337, "estimated_diameter_max"=>334.214301483}}, "is_potentially_hazardous_asteroid"=>false, "close_approach_data"=>[{"close_approach_date"=>"2019-04-10", "epoch_date_close_approach"=>1554879600000, "relative_velocity"=>{"kilometers_per_second"=>"14.9701946153", "kilometers_per_hour"=>"53892.7006150984", "miles_per_hour"=>"33486.828334976"}, "miss_distance"=>{"astronomical"=>"0.089370038", "lunar"=>"34.7649421692", "kilometers"=>"13369567", "miles"=>"8307464"}, "orbiting_body"=>"Earth"}], "is_sentry_object"=>false}
```

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


### Testing

Uses `RSpec 3.8`

Run tests:
`bundle exec rspec`
