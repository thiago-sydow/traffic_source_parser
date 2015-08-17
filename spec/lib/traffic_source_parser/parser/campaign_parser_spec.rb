require 'spec_helper'

describe TrafficSourceParser::Parser::CampaignParser do

  shared_examples_for 'a traffic source campaign parser' do |has_content: nil, has_term: nil|

    it 'should have campaign correctly set' do
      expect(subject.campaign).to eq campaign
    end

    it 'should have medium correctly set' do
      expect(subject.medium).to eq medium
    end

    it 'should have source correctly set' do
      expect(subject.source).to eq source
    end

    if has_content
      context 'with content set' do
        it 'should have content correctly set' do
          expect(subject.content).to eq content
        end
      end
    end

    if has_term
      context 'with term set' do
        it 'should have term correctly set' do
          expect(subject.term).to eq term
        end
      end
    end

  end

  describe '.parse' do

    subject { TrafficSourceParser::Parser::CampaignParser.parse(cookie) }

    context 'when value is from referral' do
      let(:cookie) { 'utm_campaign=spring&utm_medium=referral&utm_source=exampleblog' }
      let(:campaign) { 'spring' }
      let(:medium) { 'referral' }
      let(:source) { 'exampleblog' }

      it_behaves_like 'a traffic source campaign parser'
    end

    context 'when value is from email' do
      let(:cookie) { 'utm_campaign=spring&utm_medium=email&utm_source=newsletter1' }
      let(:campaign) { 'spring' }
      let(:medium) { 'email' }
      let(:source) { 'newsletter1' }

      it_behaves_like 'a traffic source campaign parser'

      context 'and has content' do
        let(:cookie) { 'utm_campaign=spring&utm_medium=email&utm_source=newsletter1&&utm_content=toplink' }
        let(:content) { 'toplink' }

        it_behaves_like 'a traffic source campaign parser', has_content: true
      end

      context 'and has term' do
        let(:cookie) { 'utm_source=Self+Test+List&utm_campaign=c2994af7da-xunda_mother_campaign&utm_medium=email&utm_term=0_f85d50388c-c2994af7da-69634449' }
        let(:campaign) { 'c2994af7da-xunda_mother_campaign' }
        let(:medium) { 'email' }
        let(:source) { 'Self+Test+List' }
        let(:term) { '0_f85d50388c-c2994af7da-69634449' }

        it_behaves_like 'a traffic source campaign parser', has_term: true
      end

    end

  end

end
