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
            
            db = RegionAnnotationDB.new(settings.db_name, 
                                        collectionname(@params[:task], :region_annotation))
            @annodata = db.all_regiondata
            gon.annodata = @annodata
        end

        def url_register_regiondb(task, operation)
            '/' + settings.entry_point + "/annotation/region/task/#{task}/#{operation}"
        end

        def register_region
            task = @params[:task]
            operation = @params[:operation]
            name = @params[:imagepath]
            region_index = @params[:region_index].to_i
            region = {
                "x" =>  @params[:x],
                "y" =>  @params[:y],
                "width" => @params[:width],
                "height" => @params[:height]
            }

            db = RegionAnnotationDB.new(settings.db_name, 
                                        collectionname(@params[:task], :region_annotation))

            case operation
            when 'add', 'update'
                unless db.exist?(name)
                    db.insert({"name" => name, "regions" => [region]})
                else
                    res = db.find_byimage(name)
                    raise ImageAnnotationAppError, "#{name} is not found" if res.nil?
                    if res["regions"].size == region_index
                        db.update(name, {"name" => name, "regions" => res["regions"].push(region)} )
                    else
                        res["regions"][region_index] = region
                        db.update(name, {"name" => name, "regions" => res["regions"]})
                    end
                end
            when 'remove'
                if db.exist?(name)
                    res = db.find_byimage(name)
                    if res.nil?
                        raise ImageAnnotationAppError, "#{name} is not found"
                    end
                    if region_index >= res["regions"].size || region_index < 0
                        raise ImageAnnotationAppError, "regions index out of range: region_index=#{region_index}" 
                    end
                    res["regions"].delete_at(region_index)
                    if res["regions"].size.zero?
                        db.remove({"name" => name})
                    else
                        db.update(name, {"name" => name, "regions" => res["regions"]})
                    end
                end
            end
            
            status 200
            db.all_regiondata
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
