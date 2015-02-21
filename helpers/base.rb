# coding: utf-8
require 'json'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

module Sinatra::ImageAnnotationApp; end     # namespace

require 'helpers/common'
require 'helpers/views'
require 'helpers/listview'
require 'helpers/annotation'
require 'helpers/label'
require 'helpers/region'

# routes and helpers for base modules
module Sinatra::ImageAnnotationApp::BaseModules
    def self.registered(app)
        app.register Sinatra::ImageAnnotationApp::Common
        app.register Sinatra::ImageAnnotationApp::Views
        app.register Sinatra::ImageAnnotationApp::Listview
    end
end

# routes and helpers for annotation modules
module Sinatra::ImageAnnotationApp::AnnotationModules
    def self.registered(app)
        app.register Sinatra::ImageAnnotationApp::Annotation
        app.register Sinatra::ImageAnnotationApp::Label
        app.register Sinatra::ImageAnnotationApp::Region
    end
end
