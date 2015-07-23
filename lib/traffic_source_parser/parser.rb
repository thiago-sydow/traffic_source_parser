require "traffic_source_parser/parser/referrer_parser"
require "traffic_source_parser/parser/campaign_parser"

module TrafficSourceParser
  module Parser
    extend self

    def create(cookie_value)
      @cookie_value = cookie_value
      parser.parse cookie_value
    end

    private

    def parser
      return CampaignParser if is_campaign?
      ReferrerParser
    end

    def is_campaign?
      @cookie_value.include?("utm_campaign=") || @cookie_value.include?("utmcsr=")
    end

  end
end