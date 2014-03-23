#!/usr/bin/ruby -w
require 'mechanize'
require 'fileutils'
require 'uri'

class SitemapDump
    def initialize(url)
        puts url
        @agent = Mechanize.new 
        @sitemap = @agent.get(url)
    end

    def dump 
        urls.each do |url|
            dpath = make_dir(url.host, url.path)
            fpath = File.join(dpath, "index.html")
            File.open(fpath, 'w') do |file| 
                puts "Getting url [#{url}] to [#{fpath}]"
                file.write(@agent.get(url).content) 
            end 
        end
    end

    private
    def urls
        url_nodes = @sitemap.search("urlset/url/loc") 
        urls = []
        url_nodes.each do |url|
            urls << URI.parse(url.content)
        end 
        return urls
    end

    def make_dir(base, path) 
        dpath = File.join("./#{base}", path)
        FileUtils.mkpath(dpath)
        return dpath
    end
end

url = ARGV[0]
SitemapDump.new(url).dump()
