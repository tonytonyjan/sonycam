module Sonycam
  class Packet
    def initialize commen_header, payload_header, jpeg_data, padding_data
      @packet = {
        commen_header: {
          start_byte: commen_header[0],          # hex, fixed "FF"
          payload_type: commen_header[1],        # int
          sequence_number: commen_header[2],     # int
          time_stamp: commen_header[3]           # int
        },
        payload_header: {
          star_code: payload_header[0],          # hex, fixed "24356879"
          jpeg_data_size: payload_header[1].hex, # int
          padding_size: payload_header[2],       # int
          reserved: payload_header[3],           # hex
          flag: payload_header[4],               # int, fixed "00"
          reserved_2: payload_header[5]
        },
        payload_data: {
          jpeg_data: jpeg_data,
          padding_data: padding_data
        }
      }
    end

    def [] key
      @packet[key]
    end
  end
end