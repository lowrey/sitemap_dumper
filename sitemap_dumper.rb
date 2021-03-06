#!/usr/bin/ruby -w
require_relative 'SiteDump'

class SitemapDump < SiteDump
    def initialize(url)
        super(url)
    end

    protected
    def urls
        url_nodes = @sitemap.search("urlset/url/loc") 
        urls = []
        url_nodes.each do |url|
            urls << URI.parse(url.content)
        end 
        return urls
    end
end

url = ARGV[0]
puts SiteDump.inspect
SitemapDump.new(url).dump()
