# frozen_string_literal: true

require_relative 'configuration'
require_relative 'client'

module NasaNeo
  module CloseObj
    def self.client
      @client
    end

    def self.configure
      @client = Client.new(Configuration.new)
    end
  end
end
