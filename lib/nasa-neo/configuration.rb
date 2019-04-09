module NasaNeo
  module CloseObj
    class Configuration
      DEFAULT_HOST = 'https://api.nasa.gov/neo/rest/v1/feed'
      DEFAULT_API_KEY = 'DEMO_KEY'

      attr_accessor :api_key, :host

      def initialize
        self.api_key = DEFAULT_API_KEY
        self.host = DEFAULT_HOST
      end

    end
  end
end
