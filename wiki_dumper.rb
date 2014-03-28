#!/usr/bin/ruby -w
require_relative 'SiteDump'

class WikiDump < SiteDump
    def initialize(articles)
        super()
        @articles = articles
    end

    protected
    def urls
        @articles.map do |a| 
            a.strip!
            a.gsub!(" ", "_")
            a.prepend("http://en.wikipedia.org/wiki/")
            a = URI.parse(a)
        end
    end
end

csv = ARGV[0]
WikiDump.new(csv.split(",")).dump()
