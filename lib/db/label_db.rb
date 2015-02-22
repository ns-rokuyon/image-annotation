# coding: utf-8

module LabelDBMod
    def all_labeldata
        labeldata = Hash.new("no labeled")
        all.each do |item|
            labeldata[item["name"]] = item["label"]
        end
        labeldata
    end

    def find_byimage(imagepath)
        query = {"name" => imagepath}
        res = find(query)
        raise AnnotationDBError, "#{imagepath} is not in DB" if res.nil? || res.empty?
        raise AnnotationDBError, "#{imagepath} is duplicated in DB" if res.size != 1
        row = res.first
        row.delete('_id')
        row
    end

end

class AnnotationDB
    include LabelDBMod
end
