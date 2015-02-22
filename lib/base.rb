# coding: utf-8
require 'json'
require 'yaml'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

module Sinatra::ImageAnnotationApp; end     # namespace

require 'lib/exception'
require 'lib/db'

require 'lib/helpers/common'
require 'lib/helpers/views'
require 'lib/helpers/listview'
require 'lib/helpers/annotation'
require 'lib/helpers/label'
require 'lib/helpers/region'

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
