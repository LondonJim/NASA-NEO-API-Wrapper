require_relative 'configuration'
require_relative 'client'

module NEO
  module CloseObj
    def self.client
      @client
    end

    def self.configure
      @client = Client.new(Configuration.new)
    end
  end
end
