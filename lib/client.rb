require 'open-uri'
require 'json'

module NEO
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
        retrieve_neo["estimated_diameter"]
      end

      def miss_distance
        retrieve_neo["close_approach_data"][0]["miss_distance"]
      end

      def neo_name
        retrieve_neo["name"]
      end

      def velocity
        retrieve_neo["close_approach_data"][0]["relative_velocity"]
      end

      private

      def set_full_url
        "#{@config.host}?start_date=#{@date}&end_date=#{@date}&detailed=false&api_key=#{@key}"
      end

      def retrieve_neo
        get_api_data if @full_url != set_full_url
        @result["near_earth_objects"]["#{@date}"][0]
      end

      def buffer_url
        open(@full_url)
      end

      def parsed_date
        Time.now.strftime("%Y-%m-%d")
      end

      def get_api_data
        @full_url = set_full_url
        buffer = buffer_url.read
        @result = JSON.parse(buffer)
      end

    end
  end
end
