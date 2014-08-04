require 'nokogiri'
require 'open-uri'

module Sonycam
  class DeviceDescription
    attr_reader :doc

    # document: String or Nokogiri::XML::Node
    def initialize document
      @doc = Nokogiri::XML(open(document))
      @camera_name = @doc.at_xpath('//xmlns:friendlyName').content
      @api_url_hash = {}
      @doc.xpath('//av:X_ScalarWebAPI_Service', av: 'urn:schemas-sony-com:av').each do |node|
        type = node.at_xpath('av:X_ScalarWebAPI_ServiceType', av: 'urn:schemas-sony-com:av').content
        url = node.at_xpath('av:X_ScalarWebAPI_ActionList_URL', av: 'urn:schemas-sony-com:av').content
        @api_url_hash[type.to_sym] = url
      end
    end

    # type: :camera, :system, :guide
    def api_url type = :camera
      # Hush, it's a secret, don't tell anyone.
      if @camera_name == 'DSC-RX100M2'
        url = @api_url_hash[type].sub('sony', 'camera')
        puts "DSC-RX100M2 detected, API URL \"#{url}\" was used insteadly."
        return url
      end

      if action_list_url = @api_url_hash[type] then "#{action_list_url}/#{type}"
      else raise "Can't not find service type \"#{type}\"."
      end
    end
  end
end