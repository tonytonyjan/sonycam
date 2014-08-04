# Sonycam

A Sony Camera Remote API wrapper.

## Installation

    gem install sonycam

## CLI Examples

### Liveview

Record to mp4:

    $ sonycam liveview | ffmpeg -f image2pipe -c mjpeg -i pipe:0 -codec copy liveview.mp4

ffserver Stream:

    $ ffserver -f examples/ffserver.conf
    $ sonycam liveview | ffmpeg -r 30 -f image2pipe  -c mjpeg -i pipe:0 -codec copy http://127.0.0.1:8080/feed1.ffm
    $ open examples/index.html