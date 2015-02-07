# coding: utf-8
require 'sinatra/base'
require 'yaml'

module Sinatra
    module CommonHelper
        class Imagefile
            include Comparable

            def initialize(path, baseurl)
                @filename = path.split('/').last
                @name = @filename.split('.').first
                @path = path
                @url = path.gsub('public', baseurl)
            end

            def <=>(other)
                @filename <=> other.filename
            end

            attr_reader :filename, :name, :path, :url
        end

        Listfile = Struct.new(:filename, :path, :url, :content) do
            def load_content!
                if filename.nil?
                    self.content = nil
                    return self
                end
                ex = filename.split('.').last
                if ex == "yaml"
                    self.content = YAML.load_file(path)
                else
                    self.content = File.open(path, 'r') do |fp|
                        fp.readlines
                    end
                end
                self
            end

            def name
                self.filename.split('.').first
            end

            def name?(_name)
                _name == name
            end
        end

        def partial_erb(name, options={})
            erb "partial/_#{name}".to_sym, options.merge(:layout => false)
        end

        def nowurl()
            urlbase = request.url.split('?')[0]
            unless settings.http_port == 80
                urlbase.sub!(/([^\/])\/([^\/])/, "\\1:#{settings.http_port}/\\2")
            end
            urlbase
        end

        def routeurl()
            route = nowurl.sub(appbaseurl, '').sub(/^\//,'').split('/')[0]
            appbaseurl + '/' + route
        end

        def appbaseurl
            "#{baseurl}/#{settings.entry_point}"
        end

        def baseurl
            if settings.http_port == 80
                "#{request.script_name}/"
            else
                "http://#{request.host}:#{settings.http_port}"
            end
        end

        def getlist(dirpath, get=:both)
            images = []
            dirs = []
            Dir.glob("#{dirpath}/*").each do |item|
                item.gsub!('//', '/')
                if FileTest.file?(item)
                    images.push(Imagefile.new(item, baseurl))
                elsif FileTest.directory?(item)
                    dirs.push(item.gsub('public/images/',''))
                end
            end
            return images if get == :image
            return dirs if get == :dir
            return images.sort, dirs.sort
        end

        def getlistfiles(dirpath)
            lists = []
            Dir.glob("#{dirpath}/*").each do |item|
                item.gsub!('//', '/')
                if FileTest.file?(item)
                    lists.push(
                        Listfile.new(
                            item.split('/')[-1],
                            item,
                            item.gsub('public', baseurl())
                        )
                    )
                end
            end
            lists.map do |list|
                list.load_content!
            end
        end

        def paging(images)
            @page_start = params[:start].nil? ? 1 : params[:start].to_i
            @page_start = 1 if @page_start < 1
            @paging = params[:paging].nil? ? settings.default_paging : params[:paging].to_i

            images.drop(@page_start - 1).take(@paging)
        end
    end

    helpers CommonHelper
end
