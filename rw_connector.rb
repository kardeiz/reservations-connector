require 'sinatra/base'
require 'active_support/core_ext'
require 'active_support/dependencies'

ActiveSupport::Dependencies.autoload_paths = ['./lib']

class RwConnector < Sinatra::Base

  set :logging, true

  get '/rwconnector', :provides => :xml do
    Connector::Router.response(params)
  end

end
