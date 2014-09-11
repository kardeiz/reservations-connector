module Connector

  class BaseConnector

    include DateHelpers

    def initialize(params = {})
      @params = params
      raise MissingParameters if missing_parameters?
    end

    def result_code
      @result_code || '0'
    end

    def result_code=(_result_code)
      @result_code = _result_code
    end

    NAMESPACES = {
      'xmlns:kwe' => 'http://www.appliancestudio.com/kwe/1.0/',
      'xmlns:rb' => 'http://www.appliancestudio.com/rb/1.0/'
    }


    def ng_model; @ng_model ||= ng_model_wrapper; end

    def ng_model_wrapper
      Nokogiri::XML::Builder.new do |xml|
        xml['kwe'].result(NAMESPACES) {
          xml['kwe'].date short_date_today(time_zone)
          xml['kwe'].time short_time_now(time_zone)
          xml['kwe'].result_code result_code
          yield xml if block_given?
        }
      end
    end

    def to_xml
      ng_model.to_xml
    end

    def missing_parameters?
      @params.values_at(*required_params).include?(nil)
    end

    def default_privacy
      {:confidential => 'no', :password_protected => 'yes'}
    end

    def required_params; []; end
    def time_zone; nil; end

  end

end
