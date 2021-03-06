#!/usr/bin/ruby -w
require 'mechanize'
require 'fileutils'
require 'uri'
require 'thwait'

class  SiteDump
    def initialize(url=nil, use_threads=true)
        @agent = Mechanize.new 
        unless url.nil?
            @sitemap = @agent.get(url)
        end
        if use_threads
            @dump_fn = self.method(:dump_t)
        else
            @dump_fn = self.method(:dump_n)
        end
    end

    def dump
        @dump_fn.call
    end

    def dump_n
        urls.each do |url|
            dump_url(url)
        end 
    end

    def dump_t
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
            begin 
                file.write(@agent.get(url).content) 
                puts "url [#{url}] saved to [#{fpath}]"
            rescue Mechanize::ResponseCodeError => e
                puts e.inspect
                FileUtils.rm_rf(dpath)
            end
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
