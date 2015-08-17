require "traffic_source_parser/version"
require "traffic_source_parser/parser"

module TrafficSourceParser
  extend self

  CONFIG_PATH = File.join File.dirname(__dir__), "config"
  REFERRER_CONFIG = YAML.load_file(File.join(CONFIG_PATH, 'referrers.yml'))
  CAMPAIGN_CONFIG = YAML.load_file(File.join(CONFIG_PATH, 'campaign_params.yml'))

  def parse(cookie_value)
    Parser.create cookie_value
  end

end
