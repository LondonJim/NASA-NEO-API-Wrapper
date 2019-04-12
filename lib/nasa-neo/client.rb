# frozen_string_literal: true

require 'open-uri'
require 'json'

module NasaNeo
  module CloseObj
    class Client

      ESTIMATED_DIAMETER_OPTIONS = ["kilometers", "meters", "miles", "feet"]
      MISS_DISTANCE_OPTIONS = ["astronomical", "lunar", "kilometers", "miles"]
      VELOCITY_OPTIONS = ["kilometers_per_second", "kilometers_per_hour", "miles_per_hour"]

      NEO_NAME_KEYS = ["name"]
      HAZARDOUS_KEYS = ["is_potentially_hazardous_asteroid"]
      ESTIMATED_DIAMETER_KEYS = ["estimated_diameter"]
      MISS_DISTANCE_KEYS = ["close_approach_data", 0, "miss_distance"]
      VELOCITY_KEYS = ["close_approach_data", 0, "relative_velocity"]

      attr_accessor :date, :key

      def initialize(config)
        @config = config
        @key = config.api_key
        @date = parsed_date
        @full_url = nil
        @result = nil
        @neo_position = 0
      end

      def estimated_diameter(measurement = nil, min_max = nil)
        if ESTIMATED_DIAMETER_OPTIONS.include? measurement
          if ["min", "max"].include? min_max
            call_and_rescue { retrieve_neo(ESTIMATED_DIAMETER_KEYS + ["#{measurement}", "estimated_diameter_#{min_max}"]) }
          else
            min_max == nil ? call_and_rescue { retrieve_neo(ESTIMATED_DIAMETER_KEYS + ["#{measurement}"]) }
                           : error_feedback(['min_max', 'check arguments'])
          end
        else
          measurement == nil ? call_and_rescue { retrieve_neo(ESTIMATED_DIAMETER_KEYS) }
                             : error_feedback(['measurement', 'check arguments'])
        end
      end

      def hazardous?
        call_and_rescue { retrieve_neo(HAZARDOUS_KEYS) }
      end

      def miss_distance(measurement = nil)
        if MISS_DISTANCE_OPTIONS.include? measurement
          call_and_rescue { retrieve_neo(MISS_DISTANCE_KEYS + ["#{measurement}"]).to_f }
        else
          measurement == nil ? call_and_rescue { retrieve_neo(MISS_DISTANCE_KEYS) }
                             : error_feedback(['measurement', 'check arguments'])
        end
      end

      def neo_name
        call_and_rescue { retrieve_neo(NEO_NAME_KEYS) }
      end

      def neo_data
        call_and_rescue { retrieve_neo }
      end

      def neo_total
        if @full_url != set_full_url
          call_and_rescue { get_api_data["element_count"]}
        else
          @result["element_count"]
        end
      end

      def update
        call_and_rescue { get_api_data }
      end

      def neo_select(n)
        @neo_position = n - 1
      end

      def velocity(measurement = nil)
        if VELOCITY_OPTIONS.include? measurement
          call_and_rescue { retrieve_neo(VELOCITY_KEYS + ["#{measurement}"]).to_f }
        else
          measurement == nil ? call_and_rescue { retrieve_neo(VELOCITY_KEYS) }
                             : error_feedback(['measurement', 'check arguments'])
        end
      end

      private

      def buffer_url
        open(@full_url).read
      end

      def call_and_rescue
        yield if block_given?
        rescue OpenURI::HTTPError => e
          @full_url = nil
          error_feedback(e.io.status)
      end

      def get_api_data
        @full_url = set_full_url
        @neo_position = 0
        buffer = JSON.parse(buffer_url)
        @result = buffer
      end

      def parsed_date
        Time.now.strftime("%Y-%m-%d")
      end

      def retrieve_neo(keys = [])
        get_api_data if @full_url != set_full_url
        root_keys = ["near_earth_objects", "#{@date}", @neo_position]
        @result.dig(*root_keys + keys)
      end

      def error_feedback(error_info)
        { 'error': error_info }
      end

      def set_full_url
        "#{@config.host}?start_date=#{@date}&end_date=#{@date}&detailed=false&api_key=#{@key}"
      end

    end
  end
end
