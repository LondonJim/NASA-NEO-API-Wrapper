# frozen_string_literal: true

require 'open-uri'
require 'json'

module NasaNeo
  module CloseObj
    class Client

      attr_accessor :date, :key

      def initialize(config)
        @config = config
        @key = config.api_key
        @date = parsed_date
        @full_url = nil
        @result = nil
        @neo_position = 0
        @estimated_diameter_options = ["kilometers", "meters", "miles", "feet"]
        @miss_distance_options = ["astronomical", "lunar", "kilometers", "miles"]
        @velocity_options = ["kilometers_per_second", "kilometers_per_hour", "miles_per_hour"]
      end

      def estimated_diameter(measurement = nil, min_max = nil)
        if @estimated_diameter_options.include? measurement
          if ["min", "max"].include? min_max
            call_and_rescue { estimated_diameter_data[measurement]["estimated_diameter_#{min_max}"] }
          else
            min_max == nil ? call_and_rescue { estimated_diameter_data[measurement] }
                           : error_feedback(['min_max', 'check arguments'])
          end
        else
          measurement == nil ? call_and_rescue { estimated_diameter_data }
                             : error_feedback(['measurement', 'check arguments'])
        end
      end

      def hazardous?
        call_and_rescue { hazardous_data }
      end

      def miss_distance(measurement = nil)
        if @miss_distance_options.include? measurement
          call_and_rescue { miss_distance_data[measurement].to_f }
        else
          measurement == nil ? call_and_rescue { miss_distance_data }
                             : error_feedback(['measurement', 'check arguments'])
        end
      end

      def neo_name
        call_and_rescue { neo_name_data }
      end

      def neo_data
        call_and_rescue { retrieve_neo }
      end

      def neo_total
        call_and_rescue { get_api_data } if @full_url != set_full_url
        @result["element_count"]
      end

      def update
        call_and_rescue { get_api_data }
      end

      def neo_select(n)
        @neo_position = n - 1
      end

      def velocity(measurement = nil)
        if @velocity_options.include? measurement
          call_and_rescue { velocity_data[measurement].to_f }
        else
          measurement == nil ? call_and_rescue { velocity_data }
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
        buffer = JSON.parse(buffer_url)
        @result = buffer
      end

      def parsed_date
        Time.now.strftime("%Y-%m-%d")
      end

      def retrieve_neo
        get_api_data if @full_url != set_full_url
        @result.dig("near_earth_objects", "#{@date}", @neo_position)
      end

      def estimated_diameter_data
        data = retrieve_neo
        data == nil ? nil : data["estimated_diameter"]
      end

      def error_feedback(error_info)
        { 'error': error_info }
      end

      def hazardous_data
        data = retrieve_neo
        data == nil ? nil : data["is_potentially_hazardous_asteroid"]
      end

      def miss_distance_data
        data = retrieve_neo
        data == nil ? nil : data["close_approach_data"][0]["miss_distance"]
      end

      def neo_name_data
        data = retrieve_neo
        data == nil ? nil : data["name"]
      end

      def velocity_data
        data = retrieve_neo
        data == nil ? nil : data["close_approach_data"][0]["relative_velocity"]
      end

      def set_full_url
        "#{@config.host}?start_date=#{@date}&end_date=#{@date}&detailed=false&api_key=#{@key}"
      end

    end
  end
end
