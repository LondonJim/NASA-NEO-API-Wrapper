module NEO
  module CloseObj
    class Configuration
      DEFAULT_HOST = 'https://api.nasa.gov/neo/rest/v1/feed'

      attr_accessor :api_key, :full_url, :current_date

      def initialize(api_key)
        @api_key = api_key
        self.current_date = parsed_date
        self.full_url = set_full_url
      end

      private

      def set_full_url
        "#{DEFAULT_HOST}?start_date=#{current_date}&end_date=#{current_date}&detailed=false&api_key=#{@api_key}"
      end

      def parsed_date
        Time.now.strftime("%Y-%m-%d")
      end
    end
  end
end
