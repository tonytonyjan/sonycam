require 'rexml/document'
require 'open-uri'

module Sonycam
  class DeviceDescription
    attr_reader :doc

    def initialize document
      @doc = REXML::Document.new(open(document))
      @camera_name = REXML::XPath.first(@doc, "//xmlns:friendlyName").text
      @api_url_hash = {}
      REXML::XPath.each(@doc, '//av:X_ScalarWebAPI_Service') do |element|
        type = REXML::XPath.first(element, 'av:X_ScalarWebAPI_ServiceType').text
        url = REXML::XPath.first(element, 'av:X_ScalarWebAPI_ActionList_URL').text
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
      else raise "Can not find service type \"#{type}\"."
      end
    end
  end
end