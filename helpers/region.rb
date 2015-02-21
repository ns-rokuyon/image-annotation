# coding: utf-8
require 'sinatra/base'

module Sinatra::ImageAnnotationApp::Region
    module Helpers
        def route_region_annotation_list
            @lists = getlistfiles(settings.region_annotation["conf_dir"])
        end

        def route_region_annotation
            # @list = getlistfiles(settings.label_annotation_conf_dir).find do |listfile|
            #     listfile.name?(params[:task])
            # end
            # @labels = @list.content["labels"]
            # @labels ||= []
            #
            # @state = {}
            # @state[:nowdir] = "#{settings.image_root_dir}/#{@list.content["image_dir"]}"
            # @state[:dirpath] = @state[:nowdir]
            #
            # @images, @dirs = getlist(@state[:dirpath])
            # @state[:all_image_num] = @images.size
            #
            # @images = paging(@images)
            #
            # db = AnnotationDB.new(settings.db_name, collectionname) 
            # @annodata = db.all_labeldata
        end

    end

    def self.registered(app)
        return unless app.settings.enable_annotation_modules["region"]

        app.helpers Helpers
        app.settings.annotations.push(app::Annotations.new("Region", "annotation/region", "annotate rectangle region to images"))

        # route: region annotation task list
        app.get '/' + app.settings.entry_point + '/annotation/region/?' do
            route_region_annotation_list
            erb :region
        end
    end
end
