module TargetSystem

  class CreateReservation < BaseSystem

    def initialize(opts = {}, hash_for_auth_header = {})
      @response = self.class.post('/Services/Reservations/', {
        :body => opts.to_json,
        :headers => hash_for_auth_header
      })
    end

    def valid?
      !!(@response['message'] =~ /The reservation was created/)
    end

    def reference_number
      @response['referenceNumber']
    end

    def conflicting_reservation?
      return false unless errors?
      !@response['errors'].grep(/There are conflicting reservations/).empty?
    end

    def errors?
      !!@response['errors']
    end

  end

end
