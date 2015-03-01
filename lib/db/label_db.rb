# coding: utf-8

module LabelDBMod
    DEFAULT_LABEL = "no labeled"
    def DEFAULT_LABEL.summary
        self
    end

    def all_labeldata
        labeldata = Hash.new(DEFAULT_LABEL)
        all.each do |item|
            label = item["label"]
            def label.summary
                self
            end
            labeldata[item["name"]] = label
        end
        labeldata
    end


end

class LabelAnnotationDB < AnnotationDB
    include LabelDBMod
end
