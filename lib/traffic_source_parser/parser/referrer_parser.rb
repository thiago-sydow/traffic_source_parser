require 'traffic_source_parser/parser/referrer_parser/domain_tools'
require 'traffic_source_parser/parser/referrer_parser/social_parser'
require 'traffic_source_parser/parser/referrer_parser/search_parser'
require 'traffic_source_parser/parser/referrer_parser/generic_parser'
require 'traffic_source_parser/result/direct'
require 'traffic_source_parser/result/unknown'

module TrafficSourceParser
  module Parser
    module ReferrerParser
      extend self

      # TODO - worst module ever...REFACTOR

      REFERRER_PARSERS = {
        "social" => SocialParser,
        "search" => SearchParser
      }

      def parse(referrer)
        @referrer = referrer
        return TrafficSourceParser::Result::Unknown.new if unknown_source?
        return TrafficSourceParser::Result::Direct.new if direct_source?
        referrer_parser.result(@referrer, referrer_source)
      end

      def referrer_parser
        return  GenericParser unless params_for_referrer
        REFERRER_PARSERS[referrer_type]
      end

      def referrer_type
        params_for_referrer["type"]
      end

      def referrer_source
        return referrer_domain unless params_for_referrer
        params_for_referrer["source"]
      end

      def referrer_domain
        DomainTools.domain(@referrer.dup)
      end

      def referrer_regex
         Regexp.new(referrer_domain)
      end

      def params_for_referrer
        _, referrer_data = REFERRER_CONFIG.find do |referrer, referrer_hash|
          referrer =~ referrer_regex
        end
        referrer_data
      end

      def unknown_source?
        @referrer.nil? || @referrer.empty?
      end

      def direct_source?
        !DomainTools.valid?(@referrer)
      end

    end

  end

end
