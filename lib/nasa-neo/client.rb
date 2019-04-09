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
      end

      def estimated_diameter
        call_and_rescue { retrieve_neo["estimated_diameter"] }
      end

      def miss_distance
        call_and_rescue { retrieve_neo["close_approach_data"][0]["miss_distance"] }
      end

      def neo_name
        call_and_rescue { retrieve_neo["name"] }
      end

      def velocity
        call_and_rescue { retrieve_neo["close_approach_data"][0]["relative_velocity"] }
      end

      private

      def buffer_url
        open(@full_url).read
      end

      def call_and_rescue
        yield if block_given?
        rescue OpenURI::HTTPError => e
          @full_url = nil
          { 'error': e.io.status }
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
        @result["near_earth_objects"]["#{@date}"][0]
      end

      def set_full_url
        "#{@config.host}?start_date=#{@date}&end_date=#{@date}&detailed=false&api_key=#{@key}"
      end

    end
  end
end
