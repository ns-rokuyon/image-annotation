# coding: utf-8
require 'sinatra/base'
require 'lib/db/label_db'

module Sinatra::ImageAnnotationApp::Label
    module Helpers
        def route_label_annotation_list
            @lists = getlistfiles(settings.label_annotation["conf_dir"])
        end

        def route_label_annotation
            @list = getlistfiles(settings.label_annotation["conf_dir"]).find do |listfile|
                listfile.name?(params[:task])
            end
            @labels = @list.content["labels"]
            @labels ||= []

            @state = {}
            @state[:nowdir] = "#{settings.image_root_dir}/#{@list.content["image_dir"]}"
            @state[:dirpath] = @state[:nowdir]

            @images, @dirs = getlist(@state[:dirpath])
            @state[:all_image_num] = @images.size

            @images = paging(@images)

            db = LabelAnnotationDB.new(settings.db_name, 
                                       collectionname(@params[:task], :label_annotation)) 
            @annodata = db.all_labeldata
        rescue ImageAnnotationAppError => e
            logger.error e.message
            status 500
            raise
        end


        def url_register_labeldb(task, operation)
            '/' + settings.entry_point + "/annotation/label/task/#{task}/#{operation}"
        end

        def btn_class(anno)
            if anno == "no labeled"
                'btn-default'
            else
                'btn-success'
            end
        end

        def route_labeldb
            task = @params[:task]
            operation = @params[:operation]
            label = @params[:label]
            imagepath = @params[:imagepath]

            db = LabelAnnotationDB.new(settings.db_name, 
                                       collectionname(@params[:task],:label_annotation)) 
            if operation != 'remove'
                operation = db.exist?(imagepath) ? 'update' : 'add'
            end

            case operation
            when 'add'
                db.insert({"name" => imagepath, "label" => label})
            when 'update'
                db.update(imagepath, {"name" => imagepath, "label" => label})
            when 'remove'
                unless db.exist?(imagepath)
                    status 400
                    return nil
                end
                db.remove({"name" => imagepath})
                status 200
                return {imagepath => 'removed'}
            end
            
            verify = db.find_byimage(imagepath)
            if verify["label"] != label
                raise LabelHelperError, "#{imagepath}.label=#{verify["label"]} is not match #{label}"
            end
            status 200
            verify
        rescue ImageAnnotationAppError => e
            logger.error e.message
            status 500
            nil
        end

    end

    def self.registered(app)
        return unless app.settings.enable_annotation_modules["label"]

        app.helpers Helpers
        app.settings.annotations.push(app::Annotations.new("Label", "annotation/label", "annotate label to images"))

        # route: label annotation task list
        app.get '/' + app.settings.entry_point + '/annotation/label/?' do
            route_label_annotation_list
            erb :label
        end

        # route: label annotation
        app.get '/' + app.settings.entry_point + '/annotation/label/task/:task/?' do
            route_label_annotation
            erb :label_annotation
        end

        # route: DB API for label annotation
        app.post '/' + app.settings.entry_point + '/annotation/label/task/:task/:operation' do
            data = route_labeldb
            JSON.dump(data)
        end
    end
end
