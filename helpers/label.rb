# coding: utf-8
require 'sinatra/base'
require 'lib/label_db'

module Sinatra::ImageAnnotationApp::Label
    module Helpers
        def route_label_annotation_list
            @lists = getlistfiles(settings.label_annotation_conf_dir)
        end

        def route_label_annotation
            @list = getlistfiles(settings.label_annotation_conf_dir).find do |listfile|
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

            db = AnnotationDB.new(settings.db_name, collectionname) 
            @annodata = db.all_labeldata
        end

        def collectionname
            "#{settings.label_annotation_collection_name_prefix}#{@params[:task]}"
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

            db = AnnotationDB.new(settings.db_name, collectionname) 
            operation = db.exist?(imagepath) ? 'update' : 'add'
            case operation
            when 'add'
                db.insert({"name" => imagepath, "label" => label})
            when 'update'
                db.update(imagepath, {"name" => imagepath, "label" => label})
            end
            
            verify = db.find_byimage(imagepath)
            if verify["label"] != label
                raise LabelHelperError, "#{imagepath}.label=#{verify["label"]} is not match #{label}"
            end
            status 200
            verify
        rescue => e
            warn e.message
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
        app.get '/' + app.settings.entry_point + '/annotation/label/:task/?' do
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
