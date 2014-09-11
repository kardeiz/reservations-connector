module TargetSystem

  class GetReservations < BaseSystem

    include Enumerable

    def initialize(opts = {})
      @reservations = self.class.get('/Services/Reservations/', {
        :query => opts,
        :headers => TargetSystem::Authentication.auth_user.auth_header
      })['reservations']
    end

    def each(&block); @reservations.each(&block); end

  end

end
