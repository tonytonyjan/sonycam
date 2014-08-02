module Sonycam
  module Error
    MAPPING = {
      1 => :Any,
      2 => :Timeout,
      3 => :IllegalArgument,
      4 => :IllegalDataFormat,
      5 => :IllegalRequest,
      6 => :IllegalResponse,
      7 => :IllegalState,
      8 => :IllegalType,
      9 => :IndexOutOfBounds,
      10 => :NoSuchElement,
      11 => :NoSuchField,
      12 => :NoSuchMethod,
      13 => :NULLPointer,
      14 => :UnsupportedVersion,
      15 => :UnsupportedOperation,
      40400 => :Shootingfail,
      40401 => :CameraNotReady,
      40402 => :AlreadyRunningPollingAPI147,
      40403 => :StillCapturingNotFinished,
      401 => :Unauthorized,
      403 => :Forbidden,
      404 => :NotFound,
      406 => :NotAcceptable,
      413 => :RequestEntityTooLarge,
      414 => :RequestURITooLong,
      501 => :NotImplemented,
      503 => :ServiceUnavailable
    }

    MAPPING.each_value do |error_name|
      const_set error_name, Class.new(StandardError)
    end

    def self.new_from_code code
      const_get(MAPPING[code])
    end
  end
end