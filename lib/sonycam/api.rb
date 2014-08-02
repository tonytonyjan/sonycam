require 'net/http'
require 'json'

module Sonycam
  class API
    def initialize api_url
      @uri = URI(api_url)
      @http = Net::HTTP.start(@uri.host, @uri.port)
    end

    # id property of JSON-RPC seems to be totally useless over HTTP since it's request-response pattern.
    def request method, *params, **options
      json = {method: method, params: params, id: 1, version: '1.0'}.merge!(options).to_json
      ret = JSON.parse(@http.request_post(@uri.path, json).body)
      if ret['error']
        error_code, error_message = ret['error']
        raise Sonycam::Error.new_from_code(error_code), error_message
      else
        ret
      end
    end
  end
end