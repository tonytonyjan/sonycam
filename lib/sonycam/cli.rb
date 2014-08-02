require 'thor'
require 'sonycam'
require 'open-uri'

module Sonycam
  class CLI < Thor
    DD_PATH = File.join(ENV['HOME'], '.sonycam')

    desc 'scan', 'Discover devices'
    def scan
      location = Scanner.scan.first
      puts "Found location: #{location}"
      File.write File.join(DD_PATH), open(location).read
      puts "Device description file saved to #{DD_PATH}"
    end

    desc 'list QUERY', 'List all API or search'
    def list query
      api = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      puts api.request(:getAvailableApiList)['result'].first.select{|method| method =~ /#{query}/i }
    end

    desc 'api METHOD PARAMS', 'Send API request'
    def api method, *params
      api = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      jj api.request(method, *params)
    end

    desc 'liveview', 'Start Liveview and output to STDOUT'
    def liveview
      api = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      liveview_url = api.request('startLiveview')['result'][0]
      Liveview.stream(liveview_url) do |packet|
        puts packet[:payload_data][:jpeg_data]
      end
    end
  end
end