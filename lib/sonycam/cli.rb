require 'thor'
require 'sonycam'
require 'open-uri'

module Sonycam
  class CLI < Thor
    DD_PATH = File.join(ENV['HOME'], '.sonycam')

    desc 'scan', 'Discover devices'
    def scan
      location = Scanner.scan.first
      puts "Find location: #{location}"
      File.write File.join(DD_PATH), open(location).read
      puts "Device description file saved to #{DD_PATH}"
    end

    desc 'list', 'List all API'
    def list
      api = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      puts api.request(:getAvailableApiList)['result'].first
    end

    desc 'api', 'Send API request'
    def api method, *params
      api = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      jj api.request(method, params)
    end
  end
end