require 'net/http'
require 'uri'
require 'open-uri'
require "nokogiri"

module VirginStats
  URL = "http://192.168.100.1/signal.asp"

  class Scraper
    def self.run
      get_nokogiri_document_from_url
      extract_data
    end

    private

    def self.extract_data
      data = {
        :downstream => {},
        :upstream => {}
      }
      downstream_fields =
        @@doc.xpath("//font[contains(., 'Downstream Status')]/ancestor::table//tr").
        map { |tr| tr.xpath(".//td//font").map(&:inner_html) }
      downstream_fields.each do |field|
        data[:downstream][field[0]] = field[1].tr(160.chr, '').strip
      end
      upstream_fields =
        @@doc.xpath("//font[contains(., 'Upstream Status')]/ancestor::table//tr").
        map { |tr| tr.xpath(".//td//font").map(&:inner_html) }
      upstream_fields.each do |field|
        data[:upstream][field[0]] = field[1].tr(160.chr, '').strip
      end
      data
    end

    def self.get_nokogiri_document_from_url
      @@html ||= open(URL).read.gsub(/\s+/, " ").gsub(160.chr, '')
      @@doc ||= Nokogiri.HTML(@@html)
    end
  end
end
