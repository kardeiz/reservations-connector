module Connector

  class AboutConnector < BaseConnector

    def connector_description
      'RoomWizard <-> phpScheduleIt Connector'
    end

    def connector_version
      '0.0.1'
    end

    def short_name
      connector_description
    end

    def supports_api
      ['1.0']
    end

    def ng_model
      @ng_model ||= ng_model_wrapper do |xml|
        xml['kwe'].connector {
          xml['kwe'].name connector_description
          xml['kwe'].version connector_version
          xml['kwe'].short short_name
          supports_api.each do |sa|
            xml['kwe'].api(:name => 'Room Booking API', :version => sa)
          end
        }
      end
    end
  end

end
