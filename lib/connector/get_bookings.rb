module Connector

  class GetBookings < BaseConnector

    def request
      { 
        :resourceId => room_id, 
        :scheduleId => '2',
        :startDateTime => start_datetime, 
        :endDateTime => end_datetime
      }
    end

    def reservations
      @reservations ||= TargetSystem::GetReservations.new(request)
    end

    def ng_model
      @ng_model ||= ng_model_wrapper do |xml|
        xml['rb'].bookings(:room_id => room_id) {
          reservations.each do |res|
            xml['rb'].booking({
              :booking_id => res['referenceNumber']
            }.merge(default_privacy)) {
              xml['rb'].start_date parse_datetime_for_short_date(res['startDate'], time_zone)
              xml['rb'].end_date parse_datetime_for_short_date(res['endDate'], time_zone)
              xml['rb'].start_time parse_datetime_for_short_time(res['startDate'], time_zone)
              xml['rb'].end_time parse_datetime_for_short_time(res['endDate'], time_zone)
              xml['rb'].purpose res['title']
            }
          end
        }
      end
    end

    def start_datetime
      _sdt = "#{range_start_date}#{range_start_time}"
      read_short_datetime(_sdt, time_zone).iso8601
    end

    def end_datetime
      _edt = "#{range_end_date}#{range_end_time}"
      read_short_datetime(_edt, time_zone).iso8601
    end

    %w{ range_start_date range_end_date }.each do |m|
      define_method(m) do
        parse_short_date(@params[m], time_zone).tap do |o|
          raise IncorrectDateFormat unless o =~ /\d{8}/
        end
      end
    end

    %w{ range_start_time range_end_time }.each do |m|
      define_method(m) do
        parse_short_time(@params[m], time_zone).tap do |o|
          raise IncorrectDateFormat unless o =~ /\d{6}/
        end
      end
    end

    %w{ room_id time_zone }.each do |m|
      define_method(m) { @params[m] }
    end

    def required_params
      %w{ room_id range_start_date range_start_time
        range_end_date range_end_time }
    end

  end

end
