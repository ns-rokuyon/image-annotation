# coding:utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'lib/base'

class Sinatra::ImageAnnotationApp::App < Sinatra::Base
    register Sinatra::Reloader
    register Sinatra::ConfigFile

    configure do
        enable :logging
    end

    config_file 'conf/config.yaml'

    register Sinatra::ImageAnnotationApp::BaseModules
    register Sinatra::ImageAnnotationApp::AnnotationModules

    get '/' + settings.entry_point + '/?' do
        erb :index
    end

    not_found do
        "404 Not Found"
    end

    error do
        "500 Internal Server Error"
    end

end
