require_relative 'configuration'
require_relative 'client'

module NEO
  module CloseObj
    def self.client
      @client
    end

    def self.configure(api_key = 'DEMO_KEY')
      @client = Client.new(Configuration.new(api_key))
    end
  end
end
