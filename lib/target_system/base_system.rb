module TargetSystem

  BASE_URI = 'http://url'

  class BaseSystem
    include HTTParty
    base_uri BASE_URI
  end

end
