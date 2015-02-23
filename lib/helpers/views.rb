# coding: utf-8
require 'sinatra/base'

module Sinatra::ImageAnnotationApp::Views
    module Helpers
        def bootstrap_css; "/#{settings.bootstrap_dir}/css/bootstrap.min.css" end
        def bootstrap_js;  "/#{settings.bootstrap_dir}/js/bootstrap.min.js" end
        def jcrop_css; "/#{settings.jcrop_dir}/css/jquery.Jcrop.min.css" end
        def jcrop_js;  "/#{settings.jcrop_dir}/js/jquery.Jcrop.min.js" end
        def jquery_js; "/#{settings.jquery_path.sub('public/','')}" end

        def route_link(route)
            appbaseurl + '/' + route + '/'
        end

        def interdir_list(nowdir)
            # [params]
            #   nowdir  : 'abc/def/ghi'
            # [return]
            #   Array   : ['', '/abc', '/abc/def', '/abc/def/ghi']
            arr = ['']
            nowdir.split('/').each do |item|
                arr.push("#{arr.last}/#{item}") 
            end
            arr
        end

        def pagination_li_class(value)
            if value == 'Previous'
                return 'disabled' if @page_start <= 1
                return ''
            end

            if value == 'Next'
                return 'disabled' if @page_start >= @state[:all_image_num]
                return ''
            end

            return 'active' if @page_start == value
            return 'disabled' if value >= @state[:all_image_num]
            return ''
        end

        def pagination_prevurl
            if @page_start - @paging < 1
                nowurl + "?start=1"
            else
                nowurl + "?start=#{@page_start - @paging}"
            end
        end

        def pagination_nexturl
            nowurl + "?start=#{@page_start + @paging}"
        end

        def pagination_pagingurl(start)
            nowurl + "?start=#{start}"
        end

    end

    def self.registered(app)
        app.helpers Helpers
    end

end
