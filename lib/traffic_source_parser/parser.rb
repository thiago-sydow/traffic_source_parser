require 'yaml'
require 'traffic_source_parser/parser/referrer_parser'
require 'traffic_source_parser/parser/campaign_parser'

module TrafficSourceParser
  module Parser
    extend self

    CAMPAIGN_VALUES = /utmccn|utmcmd|utmcsr|utmctr|utmcct|utm_source|utm_medium|utm_term|utm_content|utm_campaign/

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
      CAMPAIGN_VALUES =~ @cookie_value
    end

  end
end
