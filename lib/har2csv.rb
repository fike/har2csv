#!/usr/bin/env ruby
#--
# Copyright 2016 by Fernando Ike <fike@midstorm.org>.
# All rights reserved.
# This script is under LGPL-2
#
# har2csv exports har headers and values to csv.
#++

class Har2csv

  def harfile

    if ARGV[0].nil?
      puts "Please, add file path as argument!"
      #exit 1
    else
      file = ARGV[0]
    end

    File.read(file)
  end

  def parser(harfile)

    begin
      archive = JSON.parse(harfile)
      entries = archive['log']['entries']
    rescue => err
      puts "Could not parse archive file: #{err.to_s}"
      #exit 1
    end
  end



  def response_headers(parser)
    response_headers = parser.map do |entry|
      headers = entry['response']['headers'].map do |header|
        res_header = header['name'].capitalize
      end
    end

    response_headers.flatten!.uniq!
    response_headers.keep_if { |h|  h = 'X-Akamai-Session-Info'}
    response_headers.unshift('host','url')
    response_headers = response_headers.inject({}){ |h,(k,v)| h[k] = v; h}

  end

  def response_values(parser)
    response_values = parser.map do |entry|
    host = { "host" => Addressable::URI.parse(entry['request']['url']).host }
    url = { "url" => entry['request']['url'] }
    res_headers = entry['response']['headers'].map do |res_header|
      { res_header['name'].capitalize => res_header['value'] }
    end

    res_headers = response_headers(parser).merge(res_headers.inject(&:merge))
    res_headers = res_headers.merge(url).merge(host)

    end

  end

  def export(response_headers,response_values)
    csv_file = (("test/www.fernandoike.com.har").gsub(/\.har$/, '.csv'))
    CSV.open(csv_file, 'a+', { :force_quotes => true, :write_headers => true, :headers => response_headers.map { |key, value| key} } ) do |csv|
      response_values.map do |val|
        csv << val.values
      end

    end
  end

end

require 'addressable/uri'
require 'json'
require 'csv'
