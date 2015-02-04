# coding: utf-8
require 'sinatra/base'

module Sinatra
    module CommonHelper

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

        def baseurl()
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
                    images.push(item.gsub('public', baseurl()))
                elsif FileTest.directory?(item)
                    dirs.push(item.gsub('public/images/',''))
                end
            end
            return images if get == :image
            return dirs if get == :dir
            return images.sort, dirs.sort
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
