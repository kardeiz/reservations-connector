module TargetSystem

  USER, PASSWORD = 'admin', 'password'

  class Authentication < BaseSystem

    def self.auth_user
      return @auth_user if @auth_user && @auth_user.session_expires > (Time.now + 1.minute)
      @auth_user = Authentication.new(USER, PASSWORD)
    end

    def initialize(username, password)
      auth = {:username => username, :password => password}
      @response = self.class.post('/Services/Authentication/Authenticate', {
        :body => auth.to_json })
    end

    def valid?
      !(@response['message'] =~ /Login failed\. Invalid username or password\./)
    end

    def session_token
      @response['sessionToken']
    end

    def session_expires
      Time.parse @response['sessionExpires']
    end

    def user_id
      @response['userId']
    end

    def is_authenticated?
      @response['isAuthenticated']
    end

    def auth_header
      { 'X-phpScheduleIt-SessionToken' => session_token,
        'X-phpScheduleIt-UserId' => user_id }
    end

  end

end
