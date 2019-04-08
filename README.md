# Nasa Near Earth Object API Wrapper

Gives details on the closest Near Earth Object of the day.

## Installation

Uses `Ruby 2.6.1`

`bundle`

## Instructions
A default api key of DEMO_KEY will let you make up to 30 requests per hour (50 per day), if you have your own api key (https://api.nasa.gov/index.html#apply-for-an-api-key) you can pass it in as an argument.

Create client to make requests to the API (using demo api key):

```
client = NEO::CloseObj.configure
```

Create client to make requests to the API (using pwn api key):

```
client = NEO::CloseObj.configure("YOUR API KEY HERE")
```

##### Retrieving Information

Retrieve the name:

```
client.neo_name

eg. "(2004 VB)"
```


Retrieve the estimated diameter:

```
client.estimated_diameter

eg. {"kilometers"=>{"estimated_diameter_min"=>0.1838886721, "estimated_diameter_max"=>0.411187571}, "meters"=>{"estimated_diameter_min"=>183.8886720703, "estimated_diameter_max"=>411.1875710413}, "miles"=>{"estimated_diameter_min"=>0.1142630881, "estimated_diameter_max"=>0.2555000322}, "feet"=>{"estimated_diameter_min"=>603.309310875, "estimated_diameter_max"=>1349.040630575}}
```


Retrieve the miss distance to earth:

```
client.miss_distance

eg. {"astronomical"=>"0.1915058335", "lunar"=>"74.4957733154", "kilometers"=>"28648866", "miles"=>"17801580"}
```


Retrieve the velocity:

```
client.velocity

eg. {"kilometers_per_second"=>"14.488889894", "kilometers_per_hour"=>"52160.0036184644", "miles_per_hour"=>"32410.1978039286"}
```

## Testing

Uses `RSpec 3.8`

Run tests:
`bundle exec rspec`
