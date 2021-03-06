require 'traffic_source_parser/channels/types/base_type'

module TrafficSourceParser
  module Channels
    module Types
      module Paid
        extend self

          PAID_SEARCH_REGEX = /^(cpc|ppc|paidsearch)$/

          def channel_name
            'Paid Search'
          end

          # Traffic from the AdWords Search Network or other search engines, with a medium of "cpc" or "ppc".
          def match_source?(traffic_source)
            traffic_source[:medium] =~ PAID_SEARCH_REGEX
          end

      end
    end
  end
end
