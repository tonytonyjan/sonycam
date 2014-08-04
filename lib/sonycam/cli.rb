require 'thor'
require 'sonycam'
require 'open-uri'

module Sonycam
  class CLI < Thor
    DD_PATH = File.join(ENV['HOME'], '.sonycam')

    desc 'scan [IP]', 'Discover devices'
    long_desc <<-LONGDESC
    Send discovery requests (SSDP M-SEARCH), fetching UPnP device description into `$HOME/.sonycam`.

    A specific IP can be set to bind, for example:

    $ sonycam scan 10.0.0.1

    By default, it binds each local IP address, and uses the first one found.
    LONGDESC
    def scan ip = nil
      location = Scanner.scan(ip).first
      puts "Found location: #{location}"
      File.write File.join(DD_PATH), open(location).read
      puts "Device description file saved to #{DD_PATH}"
    end

    desc 'list [QUERY]', 'List API methods'
    long_desc <<-LONGDESC
    List or search available API methods, for example, to search API where name contains "act"

    $ sonycam list act
    LONGDESC
    def list query = nil
      apis = api_client.request(:getAvailableApiList).first
      apis.select!{|method| method =~ /#{query}/i } if query
      puts apis
    end

    desc 'api method [PARAMETER ...]', 'Send API request'
    long_desc <<-LONGDESC
    Send a camera API request. Use `sonycam list` to see all available methods.

     Take a picture:
     \x5$ sonycam api actTakePicture

     Zoom in:
     \x5$ sonycam api actZoom in start
    LONGDESC
    def api method, *params
      puts api_client.request(method, *params).to_json
    end

    desc 'liveview', 'Start liveview and output to STDOUT, it should be used with pipe'
    def liveview
      liveview_url = api_client.request('startLiveview').first
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