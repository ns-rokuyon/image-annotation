# coding: utf-8

module LabelDBMod
    def all_labeldata
        labeldata = Hash.new("no labeled")
        all.each do |item|
            labeldata[item["name"]] = item["label"]
        end
        labeldata
    end


end

class LabelAnnotationDB < AnnotationDB
    include LabelDBMod
end
