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
        begin
            @db = @connection.db(dbname)
        rescue
            @db = nil
        end
    end

    def set_collection(name)
        return nil if name.nil?
        @collection = @db.collection(name)
    rescue => e
        warn e.message
        @collection = nil
    end

    def insert(doc)
        @collection.insert(doc)     # return id
    rescue => e
        warn e.message
        nil
    end

    def all
        @collection.find
    end
end
