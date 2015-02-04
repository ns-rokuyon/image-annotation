# coding:utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

require 'helpers/common'
require 'helpers/views'
require 'helpers/listview'

class ImageViewerApp < Sinatra::Base

    register Sinatra::ConfigFile
    register Sinatra::Reloader

    config_file 'conf/config.yaml'

    helpers Sinatra::CommonHelper
    helpers Sinatra::ViewsHelper
    helpers Sinatra::ListviewHelper


    before do
        puts "before"
    end

    get '/' + settings.entry_point + '/?' do
        erb :index
    end

    get '/' + settings.entry_point + '/list/*' do
        route_listview
        erb :listview
    end

    get '/' + settings.entry_point + '/compare/*' do
        route_compare 
        erb :comp
    end

    not_found do
        "404 Not Found"
    end

    error do
        "500 Internal Server Error"
    end

end
