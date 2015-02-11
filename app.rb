# coding:utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'json'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

require 'helpers/common'
require 'helpers/views'
require 'helpers/listview'
require 'helpers/annotation'
require 'helpers/label'

class ImageViewerApp < Sinatra::Base
    register Sinatra::Reloader
    register Sinatra::ConfigFile

    config_file 'conf/config.yaml'

    helpers Sinatra::CommonHelper
    helpers Sinatra::ViewsHelper
    helpers Sinatra::ListviewHelper
    helpers Sinatra::AnnotationHelper
    helpers Sinatra::LabelHelper

    before do
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

    get '/' + settings.entry_point + '/annotation/label/?' do
        route_label_annotation_list
        erb :label
    end

    get '/' + settings.entry_point + '/annotation/label/:task/?' do
        route_label_annotation
        erb :label_annotation
    end

    get '/' + settings.entry_point + '/annotation/?' do
        route_annotation
        erb :annotation
    end

    post '/' + settings.entry_point + '/annotation/label/task/:task/:operation' do
        data = route_labeldb
        JSON.dump(data)
    end

    not_found do
        "404 Not Found"
    end

    error do
        "500 Internal Server Error"
    end

end
