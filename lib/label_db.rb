# coding: utf-8
require 'lib/db'

module LabelDBMod
    def all_labeldata
        labeldata = {}
        all.each do |item|
            labeldata[item["name"]] = item["label"]
        end
        labeldata
    end
end

class AnnotationDB
    include LabelDBMod
end
