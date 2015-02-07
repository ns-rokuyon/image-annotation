# coding: utf-8
require 'sinatra/base'
require 'lib/label_db'

module Sinatra
    module LabelHelper
        def route_label_annotation_list
            @lists = getlistfiles(settings.label_annotation_conf_dir)
        end

        def route_label_annotation
            @list = getlistfiles(settings.label_annotation_conf_dir).find do |listfile|
                listfile.name?(params[:task])
            end

            @state = {}
            @state[:nowdir] = @list.content["image_dir"]
            @state[:dirpath] = @state[:nowdir]

            @images, @dirs = getlist(@state[:dirpath])
            @state[:all_image_num] = @images.size

            @images = paging(@images)

            db = AnnotationDB.new(settings.db_name, collectionname) 
            # @images.each do |image|
            #     db.insert({:name => image.filename, :label => "hoge"})
            # end
            @annodata = db.all_labeldata
            p @annodata
        end

        def collectionname
            "#{settings.label_annotation_collection_name_prefix}#{@params[:task]}"
        end

    end

    helpers LabelHelper
end
