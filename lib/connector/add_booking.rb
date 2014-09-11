module Connector

  class AddBooking < BaseConnector

    delegate :user_id, :to => :user, :allow_nil => true, :prefix => true
    delegate :auth_header, :to => :user, :allow_nil => true, :prefix => true

    def user
      @user ||= TargetSystem::Authentication.auth_user
    end

    def request
      { 
        :resourceId => room_id, 
        :userId => user_user_id,
        :title => purpose, 
        :description => notes,
        :startDateTime => start_datetime, 
        :endDateTime => end_datetime
      }
    end

    def reservation
      @reservation ||= begin # 
        TargetSystem::CreateReservation.new(request, user_auth_header).tap do |o|
          raise ConflictingReservation if o.conflicting_reservation?
          raise OtherReservationErrors if o.errors?
        end
      end
    end

    def ng_model
      @builder ||= ng_model_wrapper do |xml|
        xml['rb'].bookings(:room_id => room_id) {
          xml['rb'].booking({
            :booking_id => reservation.reference_number
          }.merge(default_privacy)) {
            xml['rb'].start_date start_date
            xml['rb'].end_date end_date
            xml['rb'].start_time start_time
            xml['rb'].end_time end_time
            xml['rb'].purpose purpose
          }
        }
      end
    end

    def start_datetime
      _sdt = "#{start_date}#{start_time}"
      read_short_datetime(_sdt).iso8601
    end

    def end_datetime
      _edt = "#{end_date}#{end_time}"
      read_short_datetime(_edt).iso8601
    end

    %w{ start_date end_date }.each do |m|
      define_method(m) { parse_short_date(@params[m]) }
    end

    %w{ start_time end_time }.each do |m|
      define_method(m) do
        parse_short_time(@params[m]).tap do |o|
          o[2,2].to_i > 30 ? o[2,2] = '30' : o[2,2] = '00'
        end
      end
    end

    %w{ room_id purpose notes }.each do |m|
      define_method(m) { @params[m] }
    end

    def required_params
      %w{ room_id start_date start_time
          end_date end_time purpose }
    end

  end

end
