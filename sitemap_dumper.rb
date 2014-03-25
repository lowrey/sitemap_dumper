#!/usr/bin/ruby -w
require 'mechanize'
require 'fileutils'
require 'uri'
require 'thwait'

class  SiteDump
    def initialize(url)
        @agent = Mechanize.new 
        @sitemap = @agent.get(url)
    end

    def dump 
        threads = []
        urls.each do |url|
            threads << Thread.new{dump_url(url)}
        end
        ThreadsWait.all_waits(*threads)
    end

    protected
    def dump_url(url)
        dpath = make_dir(url.host, url.path)
        fpath = File.join(dpath, "index.html")
        File.open(fpath, 'w') do |file| 
            file.write(@agent.get(url).content) 
            puts "url [#{url}] saved to [#{fpath}]"
        end 
    end

    def urls
        raise "#{__method__} not implemented"
    end

    def make_dir(base, path) 
        dpath = File.join(Dir.getwd, "#{base}", path)
        FileUtils.mkpath(dpath)
        return dpath
    end
end

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
SitemapDump.new(url).dump()
