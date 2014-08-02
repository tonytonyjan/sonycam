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
      puts api_client.request(:getAvailableApiList)['result'].first.select{|method| method =~ /#{query}/i }
    end

    desc 'api METHOD PARAMS', 'Send API request'
    def api method, *params
      jj api_client.request(method, *params)
    end

    desc 'liveview', 'Start Liveview and output to STDOUT'
    def liveview
      liveview_url = api_client.request('startLiveview')['result'][0]
      Liveview.stream(liveview_url) do |packet|
        puts packet[:payload_data][:jpeg_data]
      end
    end

    no_tasks do
      def api_client
        return @api_client if @api_client.is_a? API
        unless File.exist?(DD_PATH)
          puts "Can not find #{DD_PATH}, start scanning..."
          invoke :scan, []
        end
        @api_client = API.new DeviceDescription.new(DD_PATH).api_url(:camera)
      end
    end
  end
end