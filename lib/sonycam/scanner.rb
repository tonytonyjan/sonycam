require 'socket'
require 'timeout'

module Sonycam
  module Scanner
    extend self
    # returns array of device description XML URL
    def scan ip = nil, timeout: 10
      m_search = <<-EOS
M-SEARCH * HTTP/1.1\r
HOST: 239.255.255.250:1900\r
MAN: ssdp:discover\r
MX: #{timeout}\r
ST: urn:schemas-sony-com:service:ScalarWebAPI:1\r
\r
EOS

      addresses = ip ? Array(Addrinfo.ip(ip)) : Socket.ip_address_list.reject{ |a| a.ipv4_loopback? || a.ipv6_loopback? || a.ipv6_linklocal? }
      locations = []
      addresses.map do |addr_info|
        Thread.new do
          begin
            sock = UDPSocket.new
            sock.bind(addr_info.ip_address, 0)
            sock.send(m_search, 0, '239.255.255.250', 1900)
            Timeout::timeout(timeout) do
              response = sock.recv(1024)
              headers = Hash[response.split("\r\n").map{|x| x[/^([^:]*)\s*:\s*(.*)$/]; [$1, $2]}]
              locations << headers['LOCATION'] if headers['ST'] == 'urn:schemas-sony-com:service:ScalarWebAPI:1'
            end
          rescue Timeout::Error
          rescue
            puts $!.inspect, $@
          end
        end
      end.each(&:join)
      locations
    end # def scan
  end
end