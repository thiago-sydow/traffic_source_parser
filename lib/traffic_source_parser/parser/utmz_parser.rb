require 'traffic_source_parser/parser/utmz_parser/utmz_tools'
require 'traffic_source_parser/parser/utmz_parser/utmz'

module TrafficSourceParser
  module Parser
    module UtmzParser
      extend self

      extend UtmzTools

      def parse(utmz)
        @utmz = utmz
        return Utmz.new(utmz_hash)
      end

    end
  end
end
