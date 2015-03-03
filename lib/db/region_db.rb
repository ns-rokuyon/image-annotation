# coding: utf-8
#

module RegionDBMod
    DEFAULT_REGIONS = []
    def DEFAULT_REGIONS.summary
        "0 regions"
    end

    def all_regiondata
        regiondata = Hash.new(DEFAULT_REGIONS)
        all.each do |item|
            regions = item["regions"]
            def regions.summary
                "#{self.size} regions"
            end
            regiondata[item["name"]] = regions
        end
        regiondata
    end

end

class RegionAnnotationDB < AnnotationDB
    include RegionDBMod
end

