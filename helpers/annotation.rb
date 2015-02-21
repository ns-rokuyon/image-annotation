# coding: utf-8
require 'sinatra/base'

module Sinatra::ImageAnnotationApp::Annotation
    module Helpers
        Annotations = Struct.new(:name, :route, :description)
        def route_annotation
            @annotations = settings.annotations
        end
    end

    def self.registered(app)
        app.helpers Helpers

        app.set :annotations, []
        
        # route: annotation mode list
        app.get '/' + app.settings.entry_point + '/annotation/?' do
            route_annotation
            erb :annotation
        end
    end
end
