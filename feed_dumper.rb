#!/usr/bin/ruby -w
require_relative 'SiteDump'

class RssDump < SiteDump
    def initialize(url)
        super(url)
    end

    protected
    def urls
        url_nodes = @sitemap.search("channel/item/link") 
        urls = []
        url_nodes.each do |url|
            urls << URI.parse(url.content)
        end 
        return urls
    end
end

url = ARGV[0]
RssDump.new(url).dump()
