# coding: utf-8
require 'mongo'

class AnnotationDB
    def initialize(dbname=nil, collectionname=nil)
        @connection = Mongo::Connection.new
        @db = nil
        @collection = nil
        opendb(dbname)
        set_collection(collectionname)
    end

    def opendb(dbname)
        return nil if dbname.nil?
        @db = @connection.db(dbname)
    rescue => e
        @db = nil
        raise AnnotationDBError, "#{e.message} : dbname=#{dbname}"
    end

    def set_collection(name)
        return nil if name.nil?
        @collection = @db.collection(name)
    rescue => e
        @collection = nil
        raise AnnotationDBError, "#{e.message} : name=#{name}"
    end

    def insert(doc)
        @collection.insert(doc)     # return id
    rescue => e
        raise AnnotationDBError, "#{e.message} : doc=#{doc}"
    end

    def update(name, doc)
        @collection.update({"name" => name}, doc)
    rescue => e
        raise AnnotationDBError, "#{e.message} : name=#{name}, doc=#{doc}"
    end

    def find(cond)
        @collection.find(cond).to_a
    rescue => e
        raise AnnotationDBError, "#{e.message} : cond=#{cond}"
    end

    def exist?(name)
        cond = {"name" => name}
        res = find(cond)
        return false if res.nil? || res.empty?
        true
    rescue => e
        raise AnnotationDBError, "#{e.message} : name=#{name}"
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

    def all
        @collection.find
    rescue => e
        raise AnnotationDBError, "#{e.message}"
    end
end
