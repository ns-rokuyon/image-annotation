# coding: utf-8

module RegionDBMod
    def all_regiondata
        regiondata = Hash.new(" ")
        all.each do |item|
            regiondata[item["name"]] = {
                "x" => item["x"],
                "y" => item["y"],
                "width" => item["width"],
                "height" => item["x"]
            }
        end
        regiondata
    end

end

class RegionAnnotationDB < AnnotationDB
    include RegionDBMod
end

