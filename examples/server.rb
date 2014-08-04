require 'sinatra'
require 'sonycam'

DD_PATH = File.join(ENV['HOME'], '.sonycam')
api_client = Sonycam::API.new DeviceDescription.new(DD_PATH).api_url(:camera)

get '/liveview.jpg' do
  boundary = 'i_love_ruby'
  status 200
  headers 'Content-Type' => "multipart/x-mixed-replace;boundary=#{boundary}\n"
  count = 0
  stream do |out|
    
    liveview_url = api_client.request('startLiveview').first
    Liveview.stream(liveview_url) do |packet|
      break if out.closed?
      out << <<-EOS
--#{boundary}\r
Content-Type: image/jpeg\r
\r
#{packet[:payload_data][:jpeg_data]}\r
EOS
      print "#{count += 1}\r"
    end
  end
end