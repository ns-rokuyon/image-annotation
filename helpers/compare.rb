# coding: utf-8
require 'sinatra/base'

module Sinatra
    module CompareHelper
        def route_compare()
            @state = {}
            @state[:nowdir] = params[:splat][0].sub(/\/$/,'')
            @state[:dirpath] = "public/images/output/#{@state[:nowdir]}"
            @state[:debugdir] = @state[:dirpath] + "/debug"

            @images, @dirs = getlists(@state[:dirpath])
            @info = read_info(@state[:dirpath], @images)

            @images = paging(@images)
        end

        def read_info(dirpath, images)
            logdir = dirpath + "/logs"
            info = {}
            images.each do |img|
                logfile = logdir + "/" + File.basename(img) + ".log"
                File.open(logfile) do |fp|
                    text = ""
                    fp.each_line do |line|
                        text += "#{line}"
                    end
                    info[File.basename(img)] = text
                end File.exist?(logfile)
            end
            info
        end

        private :read_info
    end

    helpers CompareHelper
end

