# Sonycam

A Sony Camera Remote API wrapper.

## Installation

    $ gem install sonycam

## CLI Usage

    $ sonycam api actTakePicture

The command above will prints the result as JSON format, you can process it with pipe, for example:

    $ sonycam api actTakePicture | ruby -rjson -e "puts JSON.parse(ARGF.read).first"

The best way to learn sonycam CLI is make use of `sonycam help` command.

## Usage

If you've already known the API URL:

```ruby
require 'sonycam'
api = Sonycam::API.new "http://10.0.0.1:10000/sony/camera"
api.request :actTakePicture
# => [["http://10.0.0.1:60152/pict130107_1832180000.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21"]]
api.request :actZoom, :in, :start
# => 0
```

Get API URL from device description:

```ruby
device = Sonycam::DeviceDescription.new "http://10.0.0.1:64321/DmsRmtDesc.xml"
device.api_url         # => "http://10.0.0.1:10000/sony/camera"
device.api_url :camera # => "http://10.0.0.1:10000/sony/camera"
device.api_url :system # => "http://10.0.0.1:10000/sony/system"
device.api_url :guide  # => "http://10.0.0.1:10000/sony/guide"
```

Get device description location:

```ruby
location = Sonycam::Scanner.scan.first
Sonycam::DeviceDescription.new location
```

`Sonycam::Scanner#scan` returns an array of URL string where device description is located. Generally, it only contains 1 element unless you connect to more than 2 cameras.

### Error Handling

```ruby
api_client.request :actZoom, :in, :asdf
# => Sonycam::Error::IllegalArgument
api_client.request :actBoom
# => Sonycam::Error::NoSuchMethod: actBoom
```

## Livestream

```ruby
Liveview.stream(liveview_url) do |packet|
  packet[:payload_data][:jpeg_data] # JPEG binary
end
```

For detail, read `PACKET.md`, `lib/sonycam/packet.rb` and `examples/server.rb`.

### CLI Example

`sonycam liveview` will print JPEG data stream to STDOUT, it can be easily used in pipe with commands such as `ffmpeg`, for example:

Record to mp4:

    $ sonycam liveview | ffmpeg -f image2pipe -c mjpeg -i pipe:0 -codec copy liveview.mp4
    $ open examples/index.html

ffserver Stream:

    $ ffserver -f examples/ffserver.conf
    $ sonycam liveview | ffmpeg -f image2pipe  -c mjpeg -i pipe:0 -codec copy http://127.0.0.1:8080/feed1.ffm
    $ open examples/index.html