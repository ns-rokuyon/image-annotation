# coding: utf-8
require 'sinatra/base'

module Sinatra
    module ListviewHelper
        def route_listview()
            @state = {}
            @state[:nowdir] = params[:splat][0].sub(/\/$/,'')
            @state[:dirpath] = "public/images/#{@state[:nowdir]}"

            @images, @dirs = getlist(@state[:dirpath])
            @state[:all_image_num] = @images.size

            @images = paging(@images)
        end
    end

    helpers ListviewHelper
end
