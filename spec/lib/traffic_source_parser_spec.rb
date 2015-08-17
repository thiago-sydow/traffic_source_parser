require 'spec_helper'

describe TrafficSourceParser do

  shared_examples_for "returns the correct object with attributes" do
    it "returns klass object with hash attributes" do
       sources.each do |source|
          cookie_value = source.delete(:cookie_value)
          parsed_result = TrafficSourceParser.parse(cookie_value)
          expect(parsed_result).to be_a klass
          source.keys.each do |key|
            expect(parsed_result.send(key)).to eq source[key]
          end
        end
    end
  end

  it 'has a version number' do
    expect(TrafficSourceParser::VERSION).not_to be nil
  end

  describe ".parse" do

    context "when cookie value is (none)" do

      let(:sources) do
        [
          {
            cookie_value: "(none)",
            source: "(direct)",
            campaign: "(direct)",
            medium: "(none)"
          }
        ]
      end

      let(:klass) {  TrafficSourceParser::Result::Direct }

      it_behaves_like "returns the correct object with attributes"

    end

    context "when cookie value is empty" do

      let(:sources) do
        [
          {
            cookie_value: '',
            source: "unknown",
            campaign: "unknown",
            medium: "unknown"
          }
        ]
      end

      let(:klass) {  TrafficSourceParser::Result::Unknown }

      it_behaves_like "returns the correct object with attributes"

    end

    context "when cookie value is nil" do

      let(:sources) do
        [
          {
            cookie_value: nil,
            source: "unknown",
            campaign: "unknown",
            medium: "unknown"
          }
        ]
      end

      let(:klass) {  TrafficSourceParser::Result::Unknown }

      it_behaves_like "returns the correct object with attributes"

    end

  	context "when source is referrer" do

  		context "and isn't a recognized referrer" do

          # source: domain (ajuda.rdstation.com.br)
           # campaign: (referral)
           # medium: referral
           # content: /xunda


  			let(:sources) do
  				[
  					{
  						cookie_value: "http://shipit.resultadosdigitais.com.br/trabalhe-conosco/",
  						source:  "resultadosdigitais.com.br",
              medium: "referral",
              campaign: "(referral)",
              term: "/trabalhe-conosco/"
  					},
  					{
  						cookie_value: "https://thoughtbot.com/locations",
  						source:  "thoughtbot.com",
              medium: "referral",
              campaign: "(referral)",
              term: '/locations'

  					},
  					{
  						cookie_value: "https://rubygems.org/",
  						source:  "rubygems.org",
              medium: "referral",
              campaign: "(referral)",

  					},
  					{
  						cookie_value: "https://www.ruby-lang.org/en/about/",
  						source:  "ruby-lang.org",
              medium: "referral",
              campaign: "(referral)",
              term: '/en/about/'
  					},
  				]
  			end

  			let(:klass) {  TrafficSourceParser::Result::Generic }

  			it_behaves_like "returns the correct object with attributes"

  		end

	    context "and is a recognized social network" do

	      let(:sources) do
	        [
	          {
              cookie_value: "https://www.facebook.com/",
              source: "Facebook", medium: "social"
            },
	          {
              cookie_value:  "http://t.co/W1pX6dNa2V",
              source: "Twitter", medium: "social"
            },
	          {
              cookie_value: "https://www.linkedin.com/",
              source: "LinkedIn", medium: "social"
            },
	          {
              cookie_value: "http://plus.url.google.com/url",
              source: "Google Plus", medium: "social"
            },
	          {
              cookie_value: "https://www.pinterest.com/",
              source: "Pinterest", medium: "social"
            }
	        ]
	      end

	      let(:klass) { TrafficSourceParser::Result::Social }

	      it_behaves_like "returns the correct object with attributes"

	    end

      context "and is a recognized search egine" do

        let(:sources) do
          [
            {
              cookie_value: "http://r.search.yahoo.com/_ylt=AwrBTv5RjZpVbJ8A" +
                            "J23z6Qt.;_ylu=X3oDMTE0MjJuYj…2fshipit.resultado" +
                            "sdigitais.com.br%2f/RK=0/RS=Y_bOYZ72hkyElUK0URY" +
                            "LlSFeQUo-",
              source: "Yahoo",
              medium: "organic"
            },
            {
              cookie_value: "http://www.bing.com/search?q=shipit+resultados" +
                            "+digitais&go=Submit&qs=n&form…esultados+digita" +
                            "is&sc=1-27&sp=-1&sk=&cvid=df2f6cabe2d343e9ab98" +
                            "d90a98fcc5c5",
              source: "Bing", term: "shipit resultados digitais",
              medium: "organic" },
            {
              cookie_value: "https://www.google.com.br/",
              source: "Google",
              medium: "organic"
            },
          ]
        end

        let(:klass) { TrafficSourceParser::Result::Search }

        it_behaves_like "returns the correct object with attributes"

      end
    end

	    context "when source is utmz" do

	      let(:sources) do
	        [
	          {
	            cookie_value: "256172697.1432831709.1.1.utmcsr=(direct)|utm" +
	                          "ccn=(direct)|utmcmd=(none)",
	            source: "(direct)",
	            campaign: "(direct)",
	            medium: "(none)"
	          },
	          {
	            cookie_value: "231152653.1432828491.1.1.utmcsr=t.co|utmccn" +
	                          "=(referral)|utmcmd=referral|utmcct=/EFzCFawFrk",
	            source: "t.co",
	            campaign: "(referral)",
	            medium: "referral",
	            content: "/EFzCFawFrk"
	          },
	          {
	            cookie_value: "10083233.1432828099.1.1.utmcsr=facebook.com|" +
	                          "utmccn=20150528-ef-aprovacaoharvard|utmcmd=social" +
	                          "media-fe",
	            source: "facebook.com",
	            campaign: "20150528-ef-aprovacaoharvard",
	            medium: "socialmedia-fe"
	          },
	          {
	            cookie_value: "153788330.1432828657.1.1.utmcsr=(direct)|utm" +
	                          "ccn=(direct)|utmcmd=(none)",
	            source: "(direct)",
	            campaign: "(direct)",
	            medium: "(none)"
	          },
	          {
	            cookie_value: "210677130.1432831711.1.1.utmcsr=rakuten|utmc" +
	                          "cn=linkshare|utmcmd=(not set)",
	            source: "rakuten",
	            campaign: "linkshare",
	            medium: "(not set)"
	          },
	          {
	            cookie_value: "10083233.1432828147.6.5.utmcsr=newsletter|ut" +
	                          "mccn=20150527|utmcmd=newsletter-ef|utmctr=communi" +
	                          "tycolleges|utmcct=programa",
	            source: "newsletter",
	            campaign: "20150527",
	            medium: "newsletter-ef",
	            term: "communitycolleges",
	            content: "programa"
	          },
	          {
	            cookie_value: "63514687.1432831892.1.1.utmcsr=adwords_gereb" +
	                          "oletos1min5_22072014|utmgclid=CNjQrtjy5MUCFQYXHwo" +
	                          "d7k0A8g|utmccn=(not set)|utmcmd=(not set)",
	            source: "adwords_gereboletos1min5_22072014",
	            campaign: "(not set)",
	            medium: "cpc"
	          },
            {
              cookie_value: "1.1111111111.1.1.utmcsr=facebook|utmccn=experim" +
                            "entar-ferramenta|utmcmd=sponsored-post|utmctr=|" +
                            "utmcct=organize-seus-negocios",
              source: "facebook",
              campaign: "experimentar-ferramenta",
              medium: "sponsored-post",
              content: "organize-seus-negocios"
            }
	        ]
	      end

	      let(:klass) { TrafficSourceParser::Result::Campaign }

	      it_behaves_like "returns the correct object with attributes"
	    end

    end

end
