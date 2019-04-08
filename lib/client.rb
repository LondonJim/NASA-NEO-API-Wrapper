require 'open-uri'
require 'json'

module NEO
  module CloseObj
    class Client
      def initialize(config)
        @config = config
      end

      def neo_name
        retrieve_neo["name"]
      end

      def miss_distance_kilometers
        retrieve_neo["close_approach_data"][0]["miss_distance"]["kilometers"].to_i
      end

      private

      def retrieve_neo
        buffer = buffer_url.read
        result = JSON.parse(buffer)
        result['near_earth_objects']["#{@config.current_date}"][0]
      end

      def buffer_url
        open(@config.full_url)
      end

    end
  end
end
