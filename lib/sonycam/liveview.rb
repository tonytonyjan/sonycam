require 'net/http'
require 'sonycam/packet'

module Sonycam
  module Liveview
    extend self
    def stream liveview_url
      uri = URI(liveview_url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri
        http.request request do |response|
          state = :commen_header
          buf = ''.force_encoding('BINARY')
          commen_header = nil
          payload_header = nil
            response.read_body do |chunk|
            buf += chunk
            until buf.empty?
              case state
              when :commen_header # 8 bytes
                break if buf.size < 8
                commen_header = buf.slice!(0, 8).unpack('H2CnN')
                state = :payload_header
              when :payload_header # 128 bytes
                break if buf.size < 128
                payload_header = buf.slice!(0, 128).unpack('H8H6CH8CH*')
                state = :payload_data
              when :payload_data
                jpeg_data_size = payload_header[1].to_i(16)
                padding_size = payload_header[2]
                break if buf.size < jpeg_data_size + padding_size
                jpeg_data = buf.slice!(0, jpeg_data_size)
                padding_data = buf.slice!(0, padding_size)
                state = :commen_header
                yield Packet.new(commen_header, payload_header, jpeg_data, padding_data)
              end # case state
              # gets
            end # until buf.empty?
          end # response.read_body do |chunk|
        end # http.request request do |response|
      end rescue retry # Net::HTTP.start(uri.host, uri.port) do |http|
    end # def stream
  end # class Liveview
end