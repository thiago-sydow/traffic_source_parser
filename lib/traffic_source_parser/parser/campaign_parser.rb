require 'traffic_source_parser/result/campaign'
require 'uri'

module TrafficSourceParser
  module Parser
    module CampaignParser
      extend self

      def parse(campaign_query)
        @campaign_query = campaign_query
        TrafficSourceParser::Result::Campaign.new(campaign_hash)
      end

      private

      def campaign_hash
        result_hash = {}

        parse_campaign_params.to_h.each do |key, value|
          translated_key = CAMPAIGN_CONFIG[key] || key
          result_hash[translated_key] = URI.unescape(value)
        end

        result_hash['medium'] = 'cpc' if result_hash.delete('utmgclid')

        result_hash
      end

      def campaign_params
        @campaign_query.scan(/(\w+=[^&|\|]*)/).flatten
      end

      def parse_campaign_params
        campaign_params.map { |param| param.split('=') }.
        delete_if { |params| params.size != 2 }
      end

    end
    
  end

end
