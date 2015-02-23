# coding: utf-8
require 'sinatra/base'
require 'lib/db/region_db'

module Sinatra::ImageAnnotationApp::Region
    module Helpers
        def route_region_annotation_list
            @lists = getlistfiles(settings.region_annotation["conf_dir"])
        end

        def route_region_annotation
            @list = getlistfiles(settings.region_annotation["conf_dir"]).find do |listfile|
                listfile.name?(params[:task])
            end

            if @list.nil?
                raise RegionHelperError, "listfile not found : #{params[:task]}"
            end
            
            @state = {}
            @state[:nowdir] = "#{settings.image_root_dir}/#{@list.content["image_dir"]}"
            @state[:dirpath] = @state[:nowdir]
            
            @images, @dirs = getlist(@state[:dirpath])
            @state[:all_image_num] = @images.size
            
            @images = paging(@images)
            
            db = RegionAnnotationDB.new(settings.db_name, collectionname) 
            @annodata = db.all_regiondata
        end

        def url_register_regiondb(task, operation)
            '/' + settings.entry_point + "/annotation/region/task/#{task}/#{operation}"
        end

        def register_region
            task = @params[:task]
            operation = @params[:operation]
            doc = {
                "name" => @params[:imagepath],
                "x" =>  @params[:x],
                "y" =>  @params[:y],
                "width" => @params[:width],
                "height" => @params[:height]
            }

            collectionname = "#{settings.region_annotation["collection_name_prefix"]}#{@params[:task]}"
            db = RegionAnnotationDB.new(settings.db_name, collectionname) 
            operation = db.exist?(doc["name"]) ? 'update' : 'add'
            case operation
            when 'add'
                db.insert(doc)
            when 'update'
                db.update(doc["name"], doc)
            end
            
            status 200
            db.find_byimage(doc["name"])
        rescue ImageAnnotationAppError => e
            logger.error e.message
            status 500
            nil
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

        # route: region annotation 
        app.get '/' + app.settings.entry_point + '/annotation/region/task/:task/?' do
            route_region_annotation
            erb :region_annotation
        end

        # route: DB API for region annotation
        app.post '/' + app.settings.entry_point + '/annotation/region/task/:task/:operation' do
            data = register_region
            JSON.dump(data)
        end
    end
end
