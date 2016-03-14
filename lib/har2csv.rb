#!/usr/bin/env ruby
#--
# Copyright 2016 by Fernando Ike <fike@midstorm.org>.
# All rights reserved.
# This script is under LGPL-2
#
# har2csv exports some har headers and values to csv.
#++
require 'addressable/uri'
require 'json'
require 'csv'


class Har2csv

  def loader
    file = ARGV[0]
    if file.nil?
      file = 'test/www.fernandoike.com.har'
    end
      if file.nil?
        puts "Couldn't load file."
        exit 1
      end

    begin
      archive = JSON.parse(File.read(file))
      entries = archive['log']['entries']
    rescue => err
      puts "Could not parse archive file: #{err.to_s}"
    end
  end

  def response_headers
    response_headers = loader.map do |entry|
      headers = entry['response']['headers'].map do |header|
        res_header = header['name'].capitalize
      end
    end

    response_headers.flatten!.uniq!
    response_headers.keep_if { |h|  h = 'X-Akamai-Session-Info'}
    response_headers.unshift('host','url')
    response_headers = response_headers.inject({}){ |h,(k,v)| h[k] = v; h}

  end

  def response_values
    data = loader.map do |entry|
    host = { "host" => Addressable::URI.parse(entry['request']['url']).host }
    url = { "url" => entry['request']['url'] }
    res_headers = entry['response']['headers'].map do |res_header|
      { res_header['name'].capitalize => res_header['value'] }
    end

    res_headers = response_headers.merge(res_headers.inject(&:merge))
    res_headers = res_headers.merge(url).merge(host)

    end

  end

  def export
    csv_file = (("test/www.fernandoike.com.har").gsub(/\.har$/, '.csv'))
    CSV.open(csv_file, 'a+', { :force_quotes => true, :write_headers => true, :headers => response_headers.map { |key, value| key} } ) do |csv|
      response_values.map do |val|
        csv << val.values
      end

    end
  end


end


har = Har2csv.new
har.export
