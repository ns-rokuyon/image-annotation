# coding: utf-8
require 'mongo'
require 'lib/exception'

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

    def update(name, doc)
        @collection.update({"name" => name}, doc)
    rescue => e
        warn e.message
        nil
    end

    def find(cond)
        @collection.find(cond).to_a
    rescue => e
        warn e.message
        nil
    end

    def exist?(name)
        cond = {"name" => name}
        res = find(cond)
        return false if res.nil? || res.empty?
        true
    rescue => e
        warn e.message
        raise
    end

    def all
        @collection.find
    end
end
