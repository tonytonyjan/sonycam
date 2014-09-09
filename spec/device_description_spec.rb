require 'sonycam/device_description'

describe Sonycam::DeviceDescription do
  it 'retrieves API URL correctly' do
    fixture_file 'DeviceDescription.xml' do |f|
      dd = Sonycam::DeviceDescription.new f
      expect(dd.api_url).to eq 'http://10.0.0.1:10000/sony/camera'
      expect(dd.api_url(:camera)).to eq 'http://10.0.0.1:10000/sony/camera'
      expect(dd.api_url(:system)).to eq 'http://10.0.0.1:10000/sony/system'
      expect(dd.api_url(:guide)).to eq 'http://10.0.0.1:10000/sony/guide'
      expect{ dd.api_url(:xxx) }.to raise_error
    end
  end
end