module Connector

  class DeleteBooking < BaseConnector

    def initialize(params = {})
      super; reservation
    end

    def user
      @user ||= begin
        _u = TargetSystem::GetReservation.new(booking_id).username.tap do |o|
          raise UnknownBooking unless o
        end
        TargetSystem::Authentication.new(_u, booking_password).tap do |o|
          raise IncorrectBookingPassword unless o.valid?
        end
      end
    end

    delegate :auth_header, :to => :user, :allow_nil => true, :prefix => true

    def reservation
      @reservation ||= begin
        TargetSystem::DeleteReservation.new(booking_id, user_auth_header).tap do |o|
          raise NotAuthorizedToChangeBooking unless o.deleted?
        end
      end
    end

    %w{ room_id booking_id booking_password }.each do |m|
      define_method(m) { @params[m] }
    end

    def required_params
      %w{ room_id booking_id booking_password }
    end

  end

end
