module Connector

  ERRORS = %w{
    MissingParameters 
    InvalidCommandParameter
    InvalidUser
    ConflictingReservation OtherReservationErrors
    IncorrectDateFormat
    UnknownBooking
    IncorrectBookingPassword 
    NotAuthorizedToChangeBooking
  }.map do |c|
    const_set(c, Class.new(StandardError))
  end

  class Router

    def self.response(params)
      rescue_wrapper do
        klass = route(params.delete('command'))
        klass.new(params).to_xml
      end
    end

    def self.route(command)
      case command
      when 'about_connector' then AboutConnector
      when 'get_bookings'    then GetBookings
      when 'add_booking'     then AddBooking
      # when 'delete_booking'  then DeleteBooking
      else raise InvalidCommandParameter
      end
    end

    def self.rescue_wrapper
      begin; yield
      rescue *ERRORS => e
        error_response(error_result_code(e))
      end
    end

    def self.error_result_code(error)
      case error
      when IncorrectDateFormat          then '1100'
      when InvalidUser                  then '1202'
      when ConflictingReservation       then '1200'
      when OtherReservationErrors       then '1201'
      when UnknownBooking               then '1300'
      when IncorrectBookingPassword     then '1301'
      when NotAuthorizedToChangeBooking then '1302'
      else '1'
      end
    end

    def self.error_response(_result_code)
      BaseConnector.new.tap do |o|
        o.result_code = _result_code
      end.to_xml
    end

  end
end
