# coding: utf-8
require 'sinatra/base'

module Sinatra::ImageAnnotationApp::Listview
    module Helpers
        def route_listview()
            @state = {}
            @state[:nowdir] = params[:splat][0].sub(/\/$/,'')
            @state[:dirpath] = "#{settings.image_root_dir}/#{@state[:nowdir]}"

            @images, @dirs = getlist(@state[:dirpath])
            @state[:all_image_num] = @images.size

            @images = paging(@images)
        end

    end

    def self.registered(app)
        app.helpers Helpers

        app.get '/' + app.settings.entry_point + '/list/*' do
            route_listview
            erb :listview
        end
    end
end
